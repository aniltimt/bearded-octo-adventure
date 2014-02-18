class CreateCrmAutoSystemTaskRules < ActiveRecord::Migration
  def change
    create_table :crm_auto_system_task_rules do |t|
      t.integer :role_id
      t.integer :task_type_id
      t.integer :template_id
      t.integer :auto_task_id
      t.timestamps
    end
  end
end
