class AddFieldToUsageContract < ActiveRecord::Migration
  def up
    add_column :usage_contracts, :aml_completion, :date
    add_column :usage_contracts, :aml_vendor_id, :integer
    add_column :usage_contracts, :carrier_contract_id, :string
    add_column :usage_contracts, :corporate, :boolean
    add_column :usage_contracts, :status_id, :integer
    add_column :usage_contracts, :effective_date, :date
    add_column :usage_contracts, :expiration, :date
    
    remove_column :usage_contracts, :uid
    remove_column :usage_contracts, :state_id
  end
  
  def down
    remove_column :usage_contracts, :aml_completion
    remove_column :usage_contracts, :aml_vendor_id
    remove_column :usage_contracts, :carrier_contract_id
    remove_column :usage_contracts, :corporate
    remove_column :usage_contracts, :status_id
    remove_column :usage_contracts, :effective_date
    remove_column :usage_contracts, :expiration
    
    add_column :usage_contracts, :uid, :string
    add_column :usage_contracts, :state_id, :integer
  end
end
