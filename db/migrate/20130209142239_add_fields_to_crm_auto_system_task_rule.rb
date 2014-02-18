class AddFieldsToCrmAutoSystemTaskRule < ActiveRecord::Migration
  def up
    add_column :crm_auto_system_task_rules, :delay, :integer
    add_column :crm_auto_system_task_rules, :label, :string
    add_column :crm_auto_system_task_rules, :name, :string
    add_column :crm_auto_system_task_rules, :status_type_id, :integer
    remove_column :crm_auto_system_task_rules, :auto_task_id
  end

  def down
    remove_column :crm_auto_system_task_rules, :delay
    remove_column :crm_auto_system_task_rules, :label
    remove_column :crm_auto_system_task_rules, :name
    remove_column :crm_auto_system_task_rules, :status_type_id
    add_column :crm_auto_system_task_rules, :auto_task_id, :integer
  end
end
