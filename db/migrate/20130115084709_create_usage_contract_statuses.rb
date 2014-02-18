class CreateUsageContractStatuses < ActiveRecord::Migration
  def up
    execute('CREATE VIEW usage_contract_statuses AS SELECT 
            * FROM clu_enums.usage_contract_statuses;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS usage_contract_statuses;')
  end
end
