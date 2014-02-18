class AddUserIdToMarketingEmailMessages < ActiveRecord::Migration
  def change
    add_column :marketing_email_messages, :user_id, :integer
  end
end
