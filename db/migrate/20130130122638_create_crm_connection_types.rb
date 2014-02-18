class CreateCrmConnectionTypes < ActiveRecord::Migration
  def up
    execute('CREATE VIEW crm_connection_types AS SELECT
            * FROM clu_enums.crm_connection_types;')
  end

  def down
    execute('DROP VIEW IF EXISTS crm_connection_types;')
  end
end
