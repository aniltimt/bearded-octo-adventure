class AddFieldsToCrmBeneficiary < ActiveRecord::Migration
  def change
    add_column :crm_beneficiaries, :birth_or_trust_date, :date
    add_column :crm_beneficiaries, :genre_id, :integer
    add_column :crm_beneficiaries, :name, :string
    add_column :crm_beneficiaries, :gender, :boolean
    add_column :crm_beneficiaries, :relationship, :string
    add_column :crm_beneficiaries, :ssn, :string
    add_column :crm_beneficiaries, :trustee, :string
  end
end
