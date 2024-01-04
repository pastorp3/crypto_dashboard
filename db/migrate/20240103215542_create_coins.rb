class CreateCoins < ActiveRecord::Migration[6.1]
  def change
    create_table :coins do |t|
      t.string :name
      t.decimal :total
      t.references :wallet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
