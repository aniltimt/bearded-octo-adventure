class AddFieldsToCrmCase < ActiveRecord::Migration
  def change
    add_column :crm_cases, :admin_asst_id, :integer
    add_column :crm_cases, :case_manager_id, :integer
    add_column :crm_cases, :manager_id, :integer
    add_column :crm_cases, :sales_asst_id, :integer
    add_column :crm_cases, :sales_coordinator_id, :integer
    add_column :crm_cases, :sales_support_id, :integer
  end
end
