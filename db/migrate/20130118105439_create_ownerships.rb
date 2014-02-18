class CreateOwnerships < ActiveRecord::Migration
  def up
    execute('CREATE VIEW ownerships AS SELECT 
            * FROM clu_enums.ownerships;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS ownerships;')
  end
end
