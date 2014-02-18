class CreateUsageSalesSupportFieldSets < ActiveRecord::Migration
  def change
    create_table :usage_sales_support_field_sets do |t|
      t.string :docusign_email
      t.string :docusign_account_id
      t.string :docusign_password
      t.string :metlife_agent_id

      t.timestamps
    end
  end
end
