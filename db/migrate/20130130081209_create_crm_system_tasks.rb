class CreateCrmSystemTasks < ActiveRecord::Migration
  def change
    create_table :crm_system_tasks do |t|
      t.integer :assigned_to
      t.integer :created_by
      t.string :recipient
      t.integer :task_type_id
      t.integer :template_id
      t.timestamps
    end
  end
end
