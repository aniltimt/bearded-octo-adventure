class CreateQuotingQuoterTypes < ActiveRecord::Migration
  def up
    execute('CREATE VIEW quoting_quoter_types AS SELECT 
            * FROM clu_enums.quoting_quoter_types;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS quoting_quoter_types;')
  end

end
