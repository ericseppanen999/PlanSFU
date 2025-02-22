class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    drop_table :users, if_exists: true
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.json :taken_courses, default: []  # Default to an empty array
      t.string :session_token
      
      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end