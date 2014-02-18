class CreateUsageLeadDistributions < ActiveRecord::Migration
  def change
    create_table :usage_lead_distributions do |t|
      t.integer :count
      t.date :date
      t.integer :agent_id

      t.timestamps
    end
  end
end
