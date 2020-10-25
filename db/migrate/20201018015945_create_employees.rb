class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :gender
      t.string :work_type
      t.integer :work_id
      t.integer :basic_wage, default: 0
      t.integer :minimun_wage, default: 0
      t.integer :house_allowance, default: 0
      t.integer :other_allowance, default: 0
      t.string :phone
      t.string :bank_card
      t.string :id_number
      t.string :work_status
      t.date :entry_date
      t.date :daparture_date
      t.date :birthday
      t.string :address
      t.string :email
      t.string :remarks


      t.timestamps
    end
  end
end
