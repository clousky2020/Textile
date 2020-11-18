class AddOurFreightToPurchaseOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_orders, :our_freight, :boolean
  end
end
