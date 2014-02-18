class CreateTaggingLeadDistributionWeights < ActiveRecord::Migration
  def change
    create_table :tagging_lead_distribution_weights do |t|
      t.integer :agent_id
      t.integer :tag_value_id
      t.integer :weight

      t.timestamps
    end
  end
end
