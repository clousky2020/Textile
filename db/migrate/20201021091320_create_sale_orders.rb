class CreateSaleOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :sale_orders do |t|
      t.string :order_id, index: true, uniq: true
      t.string :description
      t.references :sale_customer
      t.references :product
      t.references :repo
      t.references :user
      t.integer :number, default: 0
      t.string :measuring_unit
      t.decimal :weight, precision: 10, scale: 2, default: 0
      t.decimal :price, precision: 10, scale: 2, default: 0
      t.decimal :tax_rate, precision: 4, scale: 3, default: 0
      t.decimal :total_price, precision: 10, scale: 2, default: 0
      t.integer :freight, default: 0
      t.boolean :our_freight, default: false
      t.string :picture
      t.string :create_person
      t.string :check_person
      t.boolean :check_status, default: false
      t.datetime :check_time
      t.datetime :bill_time
      t.string :declare_invalid_person
      t.boolean :is_invalid, default: false
      t.datetime :declare_invalid_time
      t.boolean :is_return, default: false

      t.timestamps
    end
  end
end
