class AddCountdownAndLockVersionToUsageLeadDistributionWeights < ActiveRecord::Migration
  def change
    add_column :usage_lead_distribution_weights, :countdown, :integer
    add_column :usage_lead_distribution_weights, :lock_version, :integer
  end
end
