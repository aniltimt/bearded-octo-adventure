class AlterCryptedPasswordTypeInMarketingEmailSmtpServers < ActiveRecord::Migration
  def up
    remove_column :marketing_email_smtp_servers, :password
    change_column :marketing_email_smtp_servers, :crypted_password, :text
  end

  def down
    remove_column :marketing_email_smtp_servers, :password, :string
    change_column :marketing_email_smtp_servers, :crypted_password, :string
  end
end
