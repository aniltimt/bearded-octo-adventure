class CreateStates < ActiveRecord::Migration
  def up
    execute('CREATE VIEW states AS SELECT 
            * FROM clu_enums.states;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS states;')
  end
end
