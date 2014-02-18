class AddContactInfoIdToUsageProfiles < ActiveRecord::Migration
  def change
    remove_column :usage_profiles, :ownership_id
    remove_column :usage_profiles, :phone
    add_column :usage_profiles, :contact_info_id, :integer
  end
end
