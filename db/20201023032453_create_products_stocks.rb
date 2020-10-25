class CreateProductsStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :products_stocks do |t|
      t.belongs_to :product
      t.belongs_to :repo
      t.decimal :inventory_quantity, precision: 8, scale: 1, default: 0
      t.decimal :sales_quantity, precision: 8, scale: 1, default: 0
      t.decimal :last_price, precision: 8, scale: 2, default: 0
      t.decimal :average_price, precision: 8, scale: 2, default: 0
      t.decimal :total_price, precision: 10, scale: 2, default: 0
      t.string :status

      t.timestamps
    end
  end
end
