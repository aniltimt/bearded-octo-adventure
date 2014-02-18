class UpdateCrmStatuses < ActiveRecord::Migration
  def up
     add_column :crm_statuses, :system_task_id, :integer
  end

  def down
    remove_column :crm_statuses, :system_task_id
  end
end
