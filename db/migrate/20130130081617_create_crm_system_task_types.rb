class CreateCrmSystemTaskTypes < ActiveRecord::Migration
  def up
    execute('CREATE VIEW crm_system_task_types AS SELECT 
            * FROM clu_enums.crm_system_task_types;')
  end
  
  def down
    execute('DROP VIEW IF EXISTS crm_system_task_types;')
  end
end
