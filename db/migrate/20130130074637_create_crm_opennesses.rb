class CreateCrmOpennesses < ActiveRecord::Migration
  def up
    execute('CREATE VIEW crm_opennesses AS SELECT 
            * FROM clu_enums.crm_opennesses;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS crm_opennesses;')
  end
end
