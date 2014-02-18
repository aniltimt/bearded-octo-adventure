class AddOwnershipIdToUsageProfiles < ActiveRecord::Migration
  def change
    add_column :usage_profiles, :ownership_id, :integer
  end
end
