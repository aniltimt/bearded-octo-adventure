class UpdateCrmUserTask < ActiveRecord::Migration
  def up
    add_column :crm_user_tasks, :completed_at, :date
    add_column :crm_user_tasks, :connection_id, :integer
    add_column :crm_user_tasks, :due_at, :date
    add_column :crm_user_tasks, :label, :string
    add_column :crm_user_tasks, :status_id, :integer
    remove_column :crm_user_tasks, :task_id
  end

  def down
    remove_column :crm_user_tasks, :completed_at
    remove_column :crm_user_tasks, :connection_id
    remove_column :crm_user_tasks, :due_at
    remove_column :crm_user_tasks, :label
    remove_column :crm_user_tasks, :status_id
    add_column :crm_user_tasks
  end
end
