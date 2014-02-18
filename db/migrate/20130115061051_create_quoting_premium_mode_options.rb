class CreateQuotingPremiumModeOptions < ActiveRecord::Migration
  def up
    execute('CREATE VIEW quoting_premium_mode_options AS SELECT 
            * FROM clu_enums.quoting_premium_mode_options;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS quoting_premium_mode_options;')
  end

end
