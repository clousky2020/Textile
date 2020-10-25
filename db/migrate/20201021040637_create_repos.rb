class CreateRepos < ActiveRecord::Migration[6.0]
  def change
    create_table :repos do |t|
      t.string :name
      t.string :address
      t.string :description
      t.references :user
      t.string :status

      t.timestamps
    end
  end
end
