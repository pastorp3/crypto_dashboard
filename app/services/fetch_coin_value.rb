module FetchCoinValue
  def get_coin_value(coin)
    response = HTTParty.get("https://rest.coinapi.io/v1/exchangerate/#{coin}/USD?ApiKey=0E70CF67-EBAB-423D-9DF4-156E759A7839")
    JSON.parse(response.body)["rate"]
  end
end