class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :email
      t.boolean :is_lock, default: false
      t.datetime :lock_time
      t.timestamps
    end
  end
end
