class AddAgentOfRecordIdAndStaffAssignmentIdToUsageUsers < ActiveRecord::Migration
  def change
    rename_column :usage_users, :agent_of_record, :agent_of_record_id
    add_column :usage_users, :staff_assignment_id, :integer
  end
end
