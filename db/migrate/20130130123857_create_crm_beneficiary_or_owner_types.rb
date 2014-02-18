class CreateCrmBeneficiaryOrOwnerTypes < ActiveRecord::Migration
  def up
    execute('CREATE VIEW crm_beneficiary_or_owner_types AS SELECT
            * FROM clu_enums.crm_beneficiary_or_owner_types;')
  end

  def down
    execute('DROP VIEW IF EXISTS crm_beneficiary_or_owner_types;')
  end
end
