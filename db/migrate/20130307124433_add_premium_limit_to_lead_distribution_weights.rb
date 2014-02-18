class AddPremiumLimitToLeadDistributionWeights < ActiveRecord::Migration
  def change
    add_column :usage_lead_distribution_weights, :premium_limit, :integer
  end
end
