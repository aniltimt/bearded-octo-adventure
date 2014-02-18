class CreateMarketingSnailMailMessages < ActiveRecord::Migration
  def change
    create_table :marketing_snail_mail_messages do |t|
      t.text :body
      t.integer :template_id
      t.integer :profile_id
      t.string :recipient
      t.integer :sender_id
      t.integer :user_id
      t.integer :connection_id
      t.datetime :sent
      t.integer :failed_attempts

      t.timestamps
    end
  end
end
