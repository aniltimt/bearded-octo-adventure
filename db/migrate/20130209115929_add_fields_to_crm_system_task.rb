class AddFieldsToCrmSystemTask < ActiveRecord::Migration
  def change
    add_column :crm_system_tasks, :completed_at, :date
    add_column :crm_system_tasks, :connection_id, :integer
    add_column :crm_system_tasks, :due_at, :date
    add_column :crm_system_tasks, :label, :string
    add_column :crm_system_tasks, :status_id, :integer
    add_column :crm_system_tasks, :owner_id, :integer
    add_column :crm_system_tasks, :ownership_id, :integer
    remove_column :crm_statuses, :system_task_id
  end
end
