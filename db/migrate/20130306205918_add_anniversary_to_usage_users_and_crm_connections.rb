class AddAnniversaryToUsageUsersAndCrmConnections < ActiveRecord::Migration
  def change
    add_column :usage_users, :anniversary, :date
    add_column :crm_connections, :anniversary, :date
  end
end
