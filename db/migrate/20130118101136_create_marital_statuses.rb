class CreateMaritalStatuses < ActiveRecord::Migration
  def up
    execute('CREATE VIEW marital_statuses AS SELECT 
            * FROM clu_enums.marital_statuses;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS marital_statuses;')
  end

end
