class ChangeTotalPriceType < ActiveRecord::Migration[6.0]
  def change
    change_column :purchase_orders, :total_price, :decimal, :precision => 10, :scale => 2
    change_column :sale_orders, :total_price, :decimal, :precision => 10, :scale => 2
  end
end
