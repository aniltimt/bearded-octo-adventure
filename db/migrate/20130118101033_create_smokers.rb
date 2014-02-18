class CreateSmokers < ActiveRecord::Migration
  def up
    execute('CREATE VIEW smokers AS SELECT 
            * FROM clu_enums.smokers;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS smokers;')
  end
end
