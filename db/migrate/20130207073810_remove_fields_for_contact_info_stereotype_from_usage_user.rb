class RemoveFieldsForContactInfoStereotypeFromUsageUser < ActiveRecord::Migration
  def up
    remove_column :usage_users, :company
    remove_column :usage_users, :preferred_contact_method_id
    remove_column :usage_users, :fax
    remove_column :usage_users, :city
    remove_column :usage_users, :state_id
    remove_column :usage_users, :zip
    add_column :usage_users, :contact_info_id, :integer
  end

  def down
    add_column :usage_users, :company, :string
    add_column :usage_users, :preferred_contact_method_id, :integer
    add_column :usage_users, :fax, :string
    add_column :usage_users, :city, :string
    add_column :usage_users, :state_id, :integer
    add_column :usage_users, :zip, :string
    remove_column :usage_users, :contact_info_id
  end
end
