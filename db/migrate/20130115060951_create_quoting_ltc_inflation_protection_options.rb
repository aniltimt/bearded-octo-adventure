class CreateQuotingLtcInflationProtectionOptions < ActiveRecord::Migration
  def up
    execute('CREATE VIEW quoting_ltc_inflation_protection_options AS SELECT 
            * FROM clu_enums.quoting_ltc_inflation_protection_options;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS quoting_ltc_inflation_protection_options;')
  end
end
