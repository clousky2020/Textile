class CreateSaleOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :sale_orders do |t|
      t.string :order_id, index: true, uniq: true
      t.string :description
      t.references :sale_customer
      t.references :product
      t.belongs_to :repo
      t.belongs_to :user
      t.integer :number
      t.string :measuring_unit
      t.decimal :weight, precision: 10, scale: 1, default: 0
      t.decimal :price, precision: 8, scale: 2, default: 0
      t.decimal :tax_rate, precision: 4, scale: 3, default: 0
      t.decimal :total_price, default: 0
      t.integer :freight, default: 0
      t.string :picture
      t.string :check_status
      t.boolean :check_result, default: false
      t.string :check_person
      t.datetime :check_time
      t.datetime :create_person
      t.datetime :update_person
      t.boolean :is_return, default: false
      t.boolean :status, default: true
      t.timestamps
    end
  end
end
