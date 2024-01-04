class WalletController < ApplicationController
  def investment
    btc_investment = calculate_total_investment('Bitcoin')
    eth_investment = calculate_total_investment('Ether')
    ada_investment = calculate_total_investment('Cardano')

    render json: { btc_investment: btc_investment, eth_investment: eth_investment, ada_investment: ada_investment }
  end

  def download_data
    data = JSON.parse(params[:data])
    tab = JSON.parse(params[:tab])

    respond_to do |format|
      format.csv { send_data generate_csv(data), filename: "#{tab}_data.csv" }
      format.json { send_data data, filename: "#{tab}_data.json" }
    end
  end

  private

  def calculate_total_investment(coin)
    Wallet.last.coins.total_investment(coin)
  end

  def generate_csv(data)
    if JSON.parse(params[:tab]) == 'wallet'
      csv_data = "Name,Price,Investment,Investment Value\n"
      csv_data += "Bitcoin,$#{data['Bitcoin']['value']},#{data['Bitcoin']['investment']},#{data['Bitcoin']['investment_value']}\n"
      csv_data += "Ether,$#{data['Ether']['value']},#{data['Ether']['investment']},#{data['Ether']['investment_value']}\n"
      csv_data += "Cardano,$#{data['Cardano']['value']},#{data['Cardano']['investment']},#{data['Cardano']['investment_value']}\n"
      csv_data
    else
      csv_data = "Name,Price\n"
      csv_data += "Bitcoin,$#{data['Bitcoin']['value']}}\n"
      csv_data += "Ether,$#{data['Ether']['value']}\n"
      csv_data += "Cardano,$#{data['Cardano']['value']}\n"
      csv_data
    end
  end
end
