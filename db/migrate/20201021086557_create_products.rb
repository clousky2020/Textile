class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :specification
      t.string :measuring_unit
      t.integer :turns_number
      t.integer :production_num, default: 0
      t.integer :sale_num, default: 0
      t.decimal :labor_cost, precision: 8, scale: 2, default: 0
      t.decimal :preset_price, precision: 8, scale: 2, default: 0
      t.string :remarks
      t.string :picture

      t.timestamps
    end
  end
end
