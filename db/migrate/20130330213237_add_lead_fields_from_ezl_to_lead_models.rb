class AddLeadFieldsFromEzlToLeadModels < ActiveRecord::Migration
  def change
    add_column :contact_infos, :preferred_contact_time, :string
    add_column :crm_cases, :reason, :string
    add_column :crm_financial_infos, :asset_total, :integer
    add_column :crm_financial_infos, :liability_total, :integer
    add_column :crm_cases, :esign, :boolean, default:true
    add_column :crm_cases, :replaced_by_id, :integer
    add_column :crm_cases, :insured_is_owner, :boolean, default:false
    add_column :crm_cases, :premium_payer_id, :integer
    add_column :crm_cases, :insured_is_premium_payer, :boolean, default:false
  end
end
