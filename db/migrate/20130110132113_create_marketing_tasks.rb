class CreateMarketingTasks < ActiveRecord::Migration
  def change
    create_table :marketing_tasks do |t|
      t.integer :campaign_id
      t.integer :client_id
      t.integer :system_task_id

      t.timestamps
    end
  end
end
