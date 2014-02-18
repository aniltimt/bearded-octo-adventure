class CreateCrmPolicyTypes < ActiveRecord::Migration
  def up
    execute('CREATE VIEW crm_policy_types AS SELECT
            * FROM clu_enums.crm_policy_types;')
  end

  def down
    execute('DROP VIEW IF EXISTS crm_policy_types;')
  end
end
