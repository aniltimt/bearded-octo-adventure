class CreateCrmTasks < ActiveRecord::Migration
  def change
    create_table :crm_tasks do |t|
      t.string :label
      t.integer :task_type_id
      t.timestamps
    end
  end
end
