class AddPasswordResetToUsageUsers < ActiveRecord::Migration
  def change
    add_column :usage_users, :email, :string
  end
end
