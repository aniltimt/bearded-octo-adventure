class AddEzlFieldsToCrmCases < ActiveRecord::Migration
  def change
    remove_column :crm_cases, :approved_illustration_file
    remove_column :crm_cases, :submitted_illustration_file
    add_column :crm_cases, :flat_extra, :decimal, precision:8, scale:2
    add_column :crm_cases, :flat_extra_years, :integer
    add_column :crm_cases, :incl_1035, :decimal, precision:8, scale:2
    add_column :crm_cases, :owner_is_premium_payer, :boolean
  end

  def up
    add_attachment :crm_cases, :approved_illustration
    add_attachment :crm_cases, :submitted_illustration
  end

  def down
    remove_attachment :crm_cases, :approved_illustration
    remove_attachment :crm_cases, :submitted_illustration
  end
end
