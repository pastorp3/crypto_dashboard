# spec/controllers/wallet_controller_spec.rb
require 'rails_helper'

RSpec.describe WalletController, type: :controller do
  let(:wallet) { create(:wallet) }

  describe 'GET #investment' do
    it 'returns JSON with total investments' do
      allow(Wallet).to receive(:last).and_return(wallet)

      get :investment

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      expect(body).to have_key('btc_investment')
      expect(body).to have_key('eth_investment')
      expect(body).to have_key('ada_investment')
    end
  end

  describe 'GET #download_data' do

    it 'returns CSV data for wallet tab' do
      get :download_data, params: { 
        tab: 'wallet',
        data: '{
          "Bitcoin":
            {
              "value":150,
              "investment":10,
              "investment_value":1500
            },
          "Ether":
            {
              "value":200,
              "investment":15,
              "investment_value":3000
            },
          "Cardano":
            {
              "value":3,
              "investment":5,
              "investment_value":15
            }
        }' 
      }, format: :csv



      expect(response).to have_http_status(:success)
      expect(response.body).to include('Name,Price,Investment,Investment Value')
    end

    it 'returns CSV data for coins tab' do
      

      get :download_data, params: { 
        tab: 'coins',
        data: '{
          "Bitcoin":
            {
              "value":150
            },
          "Ether":
            {
              "value":200
            },
          "Cardano":
            {
              "value":3
            }
        }' 
      }, format: :csv

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Name,Price')
    end

    it 'returns JSON data for coins' do

      get :download_data, params: { 
        tab: 'coins',
        data: '{
          "Bitcoin":
            {
              "value":150
            },
          "Ether":
            {
              "value":200
            },
          "Cardano":
            {
              "value":3
            }
        }' 
      }, format: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({
        "Bitcoin" => { "value" => 150 },
        "Ether" => { "value" => 200 },
        "Cardano" => { "value" => 3 }
      })
    end

    it 'returns JSON data for wallet' do

      get :download_data, params: { 
        tab: 'wallet',
        data: '{
          "Bitcoin":
            {
              "value":150,
              "investment":10,
              "investment_value":1500
            },
          "Ether":
            {
              "value":200,
              "investment":15,
              "investment_value":3000
            },
          "Cardano":
            {
              "value":3,
              "investment":5,
              "investment_value":15
            }
        }' 
      }, format: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({
        "Bitcoin" => { "investment"=>10, "investment_value"=>1500, "value"=>150},
        "Ether" => { "investment"=>15, "investment_value"=>3000, "value"=>200 },
        "Cardano" => { "investment"=>5, "investment_value"=>15, "value"=>3 }
      })
    end
  end
end
