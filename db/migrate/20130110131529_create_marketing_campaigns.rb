class CreateMarketingCampaigns < ActiveRecord::Migration
  def change
    create_table :marketing_campaigns do |t|
      t.integer :owner_id
      t.integer :ownership_id

      t.timestamps
    end
  end
end
