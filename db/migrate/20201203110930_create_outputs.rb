class CreateOutputs < ActiveRecord::Migration[6.0]
  def change
    create_table :outputs do |t|
      t.references :product
      t.date :output_date
      t.references :machine
      t.integer :work_id
      t.decimal :weight, precision: 3, scale: 1
      t.timestamps
    end
  end
end
