class Wallet < ApplicationRecord
  has_many :coins, dependent: :destroy
end
