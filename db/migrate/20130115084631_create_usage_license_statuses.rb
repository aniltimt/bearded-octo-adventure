class CreateUsageLicenseStatuses < ActiveRecord::Migration
  def up
    execute('CREATE VIEW usage_license_statuses AS SELECT 
            * FROM clu_enums.usage_license_statuses;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS usage_license_statuses;')
  end
end
