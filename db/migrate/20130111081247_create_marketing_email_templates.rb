class CreateMarketingEmailTemplates < ActiveRecord::Migration
  def change
    create_table :marketing_email_templates do |t|
      t.integer :owner_id
      t.integer :ownership_id
      t.text :body
      t.string :subject

      t.timestamps
    end
  end
end
