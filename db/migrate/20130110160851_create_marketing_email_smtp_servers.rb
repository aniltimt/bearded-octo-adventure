class CreateMarketingEmailSmtpServers < ActiveRecord::Migration
  def change
    create_table :marketing_email_smtp_servers do |t|
      t.integer :owner_id
      t.integer :ownership_id
      t.string :host
      t.string :password
      t.integer :port
      t.boolean :ssl
      t.string :username
      t.string :address
      t.string :crypted_password
      t.integer :membership_id

      t.timestamps
    end
  end
end
