class CreateCrmAutoUserTaskRules < ActiveRecord::Migration
  def change
    create_table :crm_auto_user_task_rules do |t|
      t.integer :role_id
      t.integer :auto_task_id
      t.timestamps
    end
  end
end
