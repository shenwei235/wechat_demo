class AddUserToGroup < ActiveRecord::Migration
  def change
    add_column :users, :group_id, :integer
    add_column :groups, :user_id, :integer
  end
end
