class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
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
      t.string :remarks
      t.string :role, default: "employee"
      t.string :password_digest

      t.timestamps
    end
  end
end
