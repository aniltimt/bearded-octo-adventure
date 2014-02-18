class CreateMarketingEmailMessages < ActiveRecord::Migration
  def change
    create_table :marketing_email_messages do |t|
      t.string :subject
      t.integer :template_id
      t.string :topic
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
