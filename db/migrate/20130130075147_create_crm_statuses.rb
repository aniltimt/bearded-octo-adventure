class CreateCrmStatuses < ActiveRecord::Migration
  def change
    create_table :crm_statuses do |t|
      t.boolean :active
      t.integer :case_id
      t.integer :created_by
      t.boolean :current
      t.integer :openness_id
      t.integer :status_type_id
      t.integer :system_task_id
      t.timestamps
    end
  end
end
