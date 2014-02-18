class CreateUsageRoles < ActiveRecord::Migration
  def up
    execute('CREATE VIEW usage_roles AS SELECT 
            * FROM clu_enums.usage_roles;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS usage_roles;')
  end
end
