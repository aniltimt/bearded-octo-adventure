class MoveAddressEtcToTopLevelNs < ActiveRecord::Migration
  def up
    rename_table :crm_addresses, :addresses
    rename_table :crm_email_addresses, :email_addresses
    rename_table :crm_phones, :phones
    rename_table :crm_websites, :websites
  end

  def down
    rename_table :addresses, :crm_addresses
    rename_table :email_addresses, :crm_email_addresses
    rename_table :phones, :crm_phones
    rename_table :websites, :crm_websites
  end
end
