class CreateSaleCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :sale_customers do |t|
      t.string :name
      t.string :contacts
      t.string :phone
      t.string :address
      t.string :description
      t.decimal :check_money, precision: 10, scale: 2
      t.datetime :check_money_time
      t.decimal :total_collection_required, precision: 10, scale: 2, default: 0
      t.decimal :received, precision: 10, scale: 2, default: 0
      t.decimal :uncollected, precision: 10, scale: 2, default: 0

      t.timestamps
    end
  end
end
