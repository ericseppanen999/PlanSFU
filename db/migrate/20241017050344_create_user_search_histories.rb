class CreateUserSearchHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :user_search_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :search_term

      t.timestamps
    end
  end
end
