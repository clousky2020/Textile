class CreateMachines < ActiveRecord::Migration[6.0]
  def change
    create_table :machines do |t|
      t.string :specification
      t.string :remark
      t.string :company
      t.integer :machine_id

      t.timestamps
    end
  end
end
