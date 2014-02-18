class CreateMarketingSnailMailTemplates < ActiveRecord::Migration
  def change
    create_table :marketing_snail_mail_templates do |t|
      t.string :name
      t.string :body
      t.string :description
      t.boolean :enabled
      t.integer :owner_id
      t.integer :ownership_id
      t.attachment :thumbnail
      
      t.timestamps
    end
  end
end
