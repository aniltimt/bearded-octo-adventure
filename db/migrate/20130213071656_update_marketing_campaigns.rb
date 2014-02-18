class UpdateMarketingCampaigns < ActiveRecord::Migration
  def up
     add_column :marketing_campaigns, :name, :string
  end

  def down
    remove_column :marketing_campaigns, :name
  end
end
