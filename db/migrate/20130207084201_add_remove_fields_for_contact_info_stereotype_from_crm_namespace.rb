class AddRemoveFieldsForContactInfoStereotypeFromCrmNamespace < ActiveRecord::Migration
  def up
    remove_column :crm_connections, :company
    remove_column :crm_connections, :preferred_contact_method_id
    remove_column :crm_connections, :fax
    remove_column :crm_connections, :city
    remove_column :crm_connections, :state_id
    remove_column :crm_connections, :zip
    remove_column :crm_addresses, :connection_id
    remove_column :crm_addresses, :user_id
    remove_column :crm_email_addresses, :connection_id
    remove_column :crm_email_addresses, :user_id
    remove_column :crm_phones, :connection_id
    remove_column :crm_phones, :user_id
    remove_column :crm_websites, :connection_id
    remove_column :crm_websites, :user_id
    add_column :crm_addresses, :contact_info_id, :integer
    add_column :crm_email_addresses, :contact_info_id, :integer
    add_column :crm_phones, :contact_info_id, :integer
    add_column :crm_websites, :contact_info_id, :integer
    add_column :crm_owners, :contact_info_id, :integer
    add_column :crm_connections, :contact_info_id, :integer
  end

  def down
    add_column :crm_connections, :company, :string
    add_column :crm_connections, :preferred_contact_method_id, :integer
    add_column :crm_connections, :fax, :string
    add_column :crm_connections, :city, :string
    add_column :crm_connections, :state_id, :integer
    add_column :crm_connections, :zip, :string
    add_column :crm_addresses, :connection_id, :integer
    add_column :crm_addresses, :user_id, :integer
    add_column :crm_email_addresses, :connection_id, :integer
    add_column :crm_email_addresses, :user_id, :integer
    add_column :crm_phones, :connection_id, :integer
    add_column :crm_phones, :user_id, :integer
    add_column :crm_websites, :connection_id, :integer
    add_column :crm_websites, :user_id, :integer
    remove_column :crm_addresses, :contact_info_id
    remove_column :crm_email_addresses, :contact_info_id
    remove_column :crm_phones, :contact_info_id
    remove_column :crm_websites, :contact_info_id
    remove_column :crm_owners, :contact_info_id
    remove_column :crm_connections, :contact_info_id
  end
end
