class CreateProceeds < ActiveRecord::Migration[6.0]
  def change
    create_table :proceeds do |t|
      t.string :order_id
      t.references :sale_customers
      t.references :user
      t.decimal :paper_amount, precision: 10, scale: 2, default: 0
      t.decimal :actual_amount, precision: 10, scale: 2, default: 0
      t.string :remark
      t.string :account_number
      t.string :account_name
      t.string :account_from
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
