class CreateMarketingMemberships < ActiveRecord::Migration
  def change
    create_table :marketing_memberships do |t|
      t.integer :owner_id
      t.integer :ownership_id
      t.boolean :canned_template_privilege
      t.boolean :custom_template_privilege

      t.timestamps
    end
  end
end
