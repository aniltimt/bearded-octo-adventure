class CreateCrmUserTasks < ActiveRecord::Migration
  def change
    create_table :crm_user_tasks do |t|
      t.integer :created_by
      t.integer :assigned_to
      t.integer :task_id
      t.timestamps
    end
  end
end
