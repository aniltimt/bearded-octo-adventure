class AddFieldsToUsageUser < ActiveRecord::Migration
  def change
    add_column :usage_users, :note, :text
    add_column :usage_users, :manager_id, :integer
    add_column :usage_users, :commission_level_id, :integer
    add_column :usage_users, :nickname, :string
  end
end
