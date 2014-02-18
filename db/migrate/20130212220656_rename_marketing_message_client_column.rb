class RenameMarketingMessageClientColumn < ActiveRecord::Migration
  def up
    rename_column :marketing_message_media_messages, :client_id, :connection_id
    rename_column :marketing_email_messages, :client_id, :connection_id
    # rename_column :marketing_snail_mail_messages, :client_id, :connection_id
  end

  def down
    rename_column :marketing_message_media_messages, :connection_id, :client_id
    rename_column :marketing_email_messages, :connection_id, :client_id
    # rename_column :marketing_snail_mail_messages, :connection_id, :client_id
  end
end
