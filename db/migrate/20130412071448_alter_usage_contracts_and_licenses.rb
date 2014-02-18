class AlterUsageContractsAndLicenses < ActiveRecord::Migration
  def up
    remove_column :usage_contracts, :user_id
    remove_column :usage_licenses, :user_id
    add_column :usage_agent_field_sets, :aml_id, :integer
  end

  def down
  end
end
