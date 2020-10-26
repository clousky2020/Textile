class CreateSaleCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :sale_customers do |t|
      t.string :name
      t.string :contacts
      t.string :phone
      t.string :address
      t.string :description
      t.string :status

      t.timestamps
    end
  end
end
