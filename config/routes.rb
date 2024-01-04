Rails.application.routes.draw do
 root to: 'coins#index'

 get '/calculator', to: 'coins#calculator'

 post '/invest', to: 'coins#invest'

 get '/wallet_investment', to: 'wallet#investment'
 get '/wallet/download_data', to: 'wallet#download_data', as: 'download_wallet_data'

end
