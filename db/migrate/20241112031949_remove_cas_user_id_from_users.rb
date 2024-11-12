class RemoveCasUserIdFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :cas_user_id, :string
  end
end
