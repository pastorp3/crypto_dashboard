require 'csv'

module MonthlyRate
  def get_monthly_rate(coin)
    csv_path = Rails.root.join('public', 'csv', 'data.csv')

    csv_data = CSV.read(csv_path).drop(1)

    coins_data = {}
    csv_data.each do |row|
      coins_data[row[0]] = row[1].to_i
    end

    coins_data[coin] || 0
  end
end