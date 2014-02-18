class CreateMarketingAutoTaskRules < ActiveRecord::Migration
  def change
    create_table :marketing_auto_task_rules do |t|
      t.integer :campaign_id
      t.integer :auto_system_task_rule_id

      t.timestamps
    end
  end
end
