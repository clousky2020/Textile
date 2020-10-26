class CreateMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :materials do |t|
      t.string :name
      t.string :specification

      t.string :description
      t.string :measuring_unit
      t.references :purchase_supplier
      t.decimal :preset_cost, precision: 8, scale: 2, default: 0
      t.decimal :preset_price, precision: 8, scale: 2, default: 0
      t.string :remarks
      t.string :picture

      t.timestamps
    end
  end
end
