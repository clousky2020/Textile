class AssociateExpensePurchaseSupplier < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses_purchase_suppliers, id: false do |t|
      t.references :expense
      t.references :purchase_suppliers

    end
  end
end
