class RemoveEmailFromUsageUsers < ActiveRecord::Migration
  def up
    remove_column :usage_users, :email
  end
end
