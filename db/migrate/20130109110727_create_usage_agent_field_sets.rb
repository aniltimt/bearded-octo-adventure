class CreateUsageAgentFieldSets < ActiveRecord::Migration
  def change
    create_table :usage_agent_field_sets do |t|
      t.string :docusign_email
      t.string :docusign_account_id
      t.string :docusign_password
      t.datetime :last_activity_at_browser
      t.string :metlife_agent_id
      t.datetime :temporary_suspension
      t.integer :premium_limit
      t.integer :tz_max
      t.integer :tz_min

      t.timestamps
    end
  end
end
