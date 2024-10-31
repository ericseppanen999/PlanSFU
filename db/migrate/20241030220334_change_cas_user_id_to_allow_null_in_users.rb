class ChangeCasUserIdToAllowNullInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :cas_user_id, true
  end
end