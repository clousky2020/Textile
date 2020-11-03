class CreatePurchaseSuppliers < ActiveRecord::Migration[6.0]
  def change
    create_table :purchase_suppliers do |t|
      t.string :name
      t.string :contacts
      t.string :phone
      t.string :address
      t.string :description
      t.string :status

      t.decimal :check_money, precision: 10, scale: 2
      t.datetime :check_money_time

      t.decimal :total_payment_required, precision: 10, scale: 2
      t.decimal :paid, precision: 10, scale: 2
      t.decimal :unpaid, precision: 10, scale: 2

      t.timestamps
    end
  end
end
