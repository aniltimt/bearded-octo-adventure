class CreateQuotingLtcHealthClassOptions < ActiveRecord::Migration
  def up
    execute('CREATE VIEW quoting_ltc_health_class_options AS SELECT 
            * FROM clu_enums.quoting_ltc_health_class_options;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS quoting_ltc_health_class_options;')
  end

end
