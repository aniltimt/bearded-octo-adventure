class CreateCrmActivityTypes < ActiveRecord::Migration
  def up
    execute('CREATE VIEW crm_activity_types AS SELECT
            * FROM clu_enums.crm_activity_types;')
  end

  def down
    execute('DROP VIEW IF EXISTS crm_activity_types;')
  end
end
