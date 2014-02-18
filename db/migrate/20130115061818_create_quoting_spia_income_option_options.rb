class CreateQuotingSpiaIncomeOptionOptions < ActiveRecord::Migration
  def up
    execute('CREATE VIEW quoting_spia_income_option_options AS SELECT 
            * FROM clu_enums.quoting_spia_income_option_options;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS quoting_spia_income_option_options;')
  end
end
