class IncreaseStringLengthForSsnInCrmBeneficiary < ActiveRecord::Migration
  def up
    change_column :crm_beneficiaries, :ssn, :text
  end

  def down
    change_column :crm_beneficiaries, :ssn, :string
  end
end
