class Coin < ApplicationRecord
  belongs_to :wallet

  validates :name, presence: true
  validates :total, presence: true

  COIN_CODE = {
    "Bitcoin" => "BTC",
    "Ether" => "ETH",
    "Cardano" => "ADA"
  }

  def self.total_investment(coin_name)
    where(name: coin_name).sum(:total)
  end

end
