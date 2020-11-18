class AddOurFreightToSaleOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :sale_orders, :our_freight, :boolean, default: false
  end
end
