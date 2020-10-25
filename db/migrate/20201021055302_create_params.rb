class CreateParams < ActiveRecord::Migration[6.0]
  def change
    create_table :params do |t|
      t.string :name
      t.string :description
      t.boolean :status, default: true
      t.string :type

      t.timestamps
    end
  end
end
