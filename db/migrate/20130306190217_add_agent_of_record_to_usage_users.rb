class AddAgentOfRecordToUsageUsers < ActiveRecord::Migration
  def change
    add_column :usage_users, :agent_of_record, :integer
  end
end
