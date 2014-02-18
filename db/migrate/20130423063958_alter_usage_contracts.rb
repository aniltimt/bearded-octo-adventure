class AlterUsageContracts < ActiveRecord::Migration
  def up
  	add_column :usage_contracts, :agent_field_set_id, :integer
  	add_column :usage_contracts, :state_id, :integer
  	add_column :usage_contracts, :appointment, :integer
    remove_column :usage_contracts, :aml_vendor_id
    remove_column :usage_contracts, :aml_completion
  end

  def down
  end
end
