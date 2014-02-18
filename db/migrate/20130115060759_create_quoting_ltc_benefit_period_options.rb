class CreateQuotingLtcBenefitPeriodOptions < ActiveRecord::Migration
  def up
    execute('CREATE VIEW quoting_ltc_benefit_period_options AS SELECT 
            * FROM clu_enums.quoting_ltc_benefit_period_options;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS quoting_ltc_benefit_period_options;')
  end

end
