class FixWeightScale < ActiveRecord::Migration[6.0]
  def change
    change_column :purchase_orders,:weight,:decimal,precision: 8, scale: 2, default: 0
    change_column :sale_orders,:weight,:decimal,precision: 8, scale: 2, default: 0
  end
end
