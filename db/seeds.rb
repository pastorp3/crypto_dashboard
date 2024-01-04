require 'csv'

csv_path = Rails.root.join('public', 'csv', 'data.csv')

csv_data = CSV.read(csv_path).drop(1)

wallet = Wallet.create

csv_data.each do |row|
  wallet.coins.create(name: row.first, total: row.last.to_f)
end


