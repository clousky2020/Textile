class CreateChangeMachines < ActiveRecord::Migration[6.0]
  def change
    create_table :change_machines do |t|
      t.string :change_person
      t.string :contacts
      t.integer :machine_id
      t.string :machine_type
      t.integer :price
      t.date :change_date
      t.string :change_to_specification
      t.string :remark
      t.boolean :is_settle, default: false
      t.timestamps
    end
  end
end
