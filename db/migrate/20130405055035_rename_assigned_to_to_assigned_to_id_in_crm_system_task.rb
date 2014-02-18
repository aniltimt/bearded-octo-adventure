class RenameAssignedToToAssignedToIdInCrmSystemTask < ActiveRecord::Migration
  def up
    rename_column :crm_system_tasks, :assigned_to, :assigned_to_id
  end

  def down
    rename_column :crm_system_tasks, :assigned_to_id, :assigned_to
  end
end
