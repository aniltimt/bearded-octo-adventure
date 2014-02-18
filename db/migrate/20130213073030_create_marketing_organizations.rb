class CreateMarketingOrganizations < ActiveRecord::Migration
  def change
    create_table :marketing_organizations do |t|
      t.integer :group_id

      t.timestamps
    end
  end
end
