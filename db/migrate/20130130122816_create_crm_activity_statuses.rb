class CreateCrmActivityStatuses < ActiveRecord::Migration
  def up
    execute('CREATE VIEW crm_activity_statuses AS SELECT
            * FROM clu_enums.crm_activity_statuses;')
  end

  def down
    execute('DROP VIEW IF EXISTS crm_activity_statuses;')
  end
end
