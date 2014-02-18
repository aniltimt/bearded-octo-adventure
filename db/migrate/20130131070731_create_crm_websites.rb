class CreateCrmWebsites < ActiveRecord::Migration
  def change
    create_table :crm_websites do |t|
      t.integer :connection_id
      t.integer :user_id
      t.string :url

      t.timestamps
    end
  end
end
