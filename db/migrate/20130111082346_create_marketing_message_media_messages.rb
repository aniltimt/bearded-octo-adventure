class CreateMarketingMessageMediaMessages < ActiveRecord::Migration
  def change
    create_table :marketing_message_media_messages do |t|
      t.integer :template_id
      t.text :body
      t.integer :client_id
      t.integer :profile_id
      t.string :recipient
      t.integer :sender_id
      t.datetime :sent
      t.integer :failed_attempts

      t.timestamps
    end
  end
end
