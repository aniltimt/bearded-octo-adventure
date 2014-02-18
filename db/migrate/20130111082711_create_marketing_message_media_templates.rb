class CreateMarketingMessageMediaTemplates < ActiveRecord::Migration
  def change
    create_table :marketing_message_media_templates do |t|
      t.integer :owner_id
      t.integer :ownership_id
      t.text :body

      t.timestamps
    end
  end
end
