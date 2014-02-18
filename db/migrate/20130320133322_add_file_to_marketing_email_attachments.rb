class AddFileToMarketingEmailAttachments < ActiveRecord::Migration
  def change
    remove_column :marketing_email_attachments, :filepath
    add_attachment :marketing_email_attachments, :file
  end
end
