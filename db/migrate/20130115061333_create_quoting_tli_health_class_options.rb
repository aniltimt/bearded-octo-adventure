class CreateQuotingTliHealthClassOptions < ActiveRecord::Migration

  def up
    execute('CREATE VIEW quoting_tli_health_class_options AS SELECT 
            * FROM clu_enums.quoting_tli_health_class_options;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS quoting_tli_health_class_options;')
  end
end
