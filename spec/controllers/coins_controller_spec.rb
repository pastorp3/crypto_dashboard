require 'rails_helper'
require 'webmock/rspec'

RSpec.describe CoinsController, type: :controller do
  include FetchCoinValue

  before do
    allow(HTTParty).to receive(:get).and_return(
      double(body: '{"rate": 150}', code: 200)
    )
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #calculator' do
    it 'returns JSON with annual profit' do
      allow_any_instance_of(CoinsController).to receive(:get_monthly_rate).and_return(0.05)

      get :calculator, params: { coin: 'ETH', quantity: 10 }

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      expect(body).to have_key('coin')
      expect(body).to have_key('value')
    end

    it 'handles API overloading' do
      allow_any_instance_of(CoinsController).to receive(:get_monthly_rate).and_return(0.05)

      allow(HTTParty).to receive(:get).and_return(
        double(body: '{}', code: 500)
      )

      get :calculator, params: { coin: 'ETH', quantity: 10 }

      expect(response).to have_http_status(:unprocessable_entity)

      body = JSON.parse(response.body)
      expect(body).to have_key('error')
    end
  end

  describe 'POST #invest' do
    it 'returns success for valid params' do
      post :invest, params: { quantity: 10, coin: 'BTC' }
      expect(response).to have_http_status(:success)

    end

    it 'returns unprocessable_entity for invalid params' do
      post :invest, params: { quantity: -1, coin: 'BTC' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
