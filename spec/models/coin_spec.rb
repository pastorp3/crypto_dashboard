require 'rails_helper'

RSpec.describe Coin, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:total) }
  end

  describe 'associations' do
    it { should belong_to(:wallet) }
  end

  describe 'class methods' do
    describe '.total_investment' do
      let!(:btc_coin) { create(:coin, name: 'Bitcoin', total: 100) }
      let!(:eth_coin) { create(:coin, name: 'Ether', total: 150) }
      let!(:ada_coin) { create(:coin, name: 'Cardano', total: 50) }

      it 'returns the total investment for a specific coin' do
        expect(Coin.total_investment('Bitcoin')).to eq(100)
      end
    end
  end
end
