class CreateTimeZones < ActiveRecord::Migration
  def up
    execute('CREATE VIEW time_zones AS SELECT 
            * FROM clu_enums.time_zones;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS time_zones;')
  end
end
