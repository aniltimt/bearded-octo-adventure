class MoveLeadDistributionWeightsToUsage < ActiveRecord::Migration
  def up
    rename_table :tagging_lead_distribution_weights, :usage_lead_distribution_weights
  end

  def down
    rename_table :usage_lead_distribution_weights, :tagging_lead_distribution_weights
  end
end
