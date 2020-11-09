class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :user
      t.boolean :up, default: false

      t.timestamps
    end
  end
end
