class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :cas_user_id
      t.json :taken_courses, default: []  # Default to an empty array

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :cas_user_id, unique: true
  end
end