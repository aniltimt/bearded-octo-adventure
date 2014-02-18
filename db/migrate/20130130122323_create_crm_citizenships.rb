class CreateCrmCitizenships < ActiveRecord::Migration
  def up
    execute('CREATE VIEW crm_citizenships AS SELECT
            * FROM clu_enums.crm_citizenships;')
  end

  def down
    execute('DROP VIEW IF EXISTS crm_citizenships;')
  end
end
