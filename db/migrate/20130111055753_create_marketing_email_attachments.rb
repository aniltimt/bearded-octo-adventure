class CreateMarketingEmailAttachments < ActiveRecord::Migration
  def change
    create_table :marketing_email_attachments do |t|
      t.integer :message_id
      t.string :filepath

      t.timestamps
    end
  end
end
