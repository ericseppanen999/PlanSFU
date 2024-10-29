class RestructureUserTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :users, if_exists: true

    create_table :users do |t|
      t.string :cas_user_id, null: false
      t.json :taken_courses
      t.timestamps
    end

    add_index :users, :cas_user_id, unique: true
  end
end
