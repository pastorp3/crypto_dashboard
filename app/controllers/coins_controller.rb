class CoinsController < ApplicationController
  include MonthlyRate
  include FetchCoinValue

  skip_before_action :verify_authenticity_token, only: [:invest]

  before_action :load_coins_value, only: :index
  before_action :load_wallet, only: :index

  def index
  end

  def calculator
    coin_name = calculator_params[:coin]
    monthly_rate = get_monthly_rate(coin_name) / 100.0
    coin_value = get_coin_value(Coin::COIN_CODE[coin_name])
    
    if coin_value.nil?
      render json: { error: 'Api overloading - Coin value is not available, try again in a few seconds!.' }, status: :unprocessable_entity
      return
    end

    initial_invest = calculator_params[:quantity].to_f

    annual_rate = get_annual_rate(monthly_rate)
    annual_profit = calculate_annual_profit(annual_rate, initial_invest, coin_value)

    render json: { coin: annual_profit[0], value: annual_profit[1] }
  end

  def invest
    coin_name = calculator_params[:coin]
    
    wallet = Wallet.last || Wallet.create
    coin = wallet.coins.create(name: coin_name, total: calculator_params[:quantity].to_f)

    if coin.save
      render json: { total: coin.total }
    else
      render json: { error: coin.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def calculator_params
    params.permit(:quantity, :coin)
  end

  def get_annual_rate(monthly_rate)
    (1 + monthly_rate)**12 - 1
  end

  def calculate_annual_profit(annual_rate, initial_invest, coin_value)
    coin_profit = initial_invest * (1 + annual_rate)
    dollars_profit = coin_profit * coin_value

    [coin_profit, dollars_profit]
  end

  def load_coins_value
    coins = {
      btc: get_coin_value("BTC"),
      eth: get_coin_value("ETH"),
      ada: get_coin_value("ADA")
    }
    @coins_value = OpenStruct.new(coins)
  end

  def load_wallet
    @wallet = Wallet.last
  end
end
