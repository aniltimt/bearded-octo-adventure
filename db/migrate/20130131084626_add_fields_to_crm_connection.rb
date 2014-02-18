class AddFieldsToCrmConnection < ActiveRecord::Migration
  def change
    add_column :crm_connections, :asset_404k, :integer
    add_column :crm_connections, :asset_home_equity, :integer
    add_column :crm_connections, :asset_investments, :integer
    add_column :crm_connections, :asset_pension, :integer
    add_column :crm_connections, :asset_real_estate, :integer
    add_column :crm_connections, :asset_savings, :integer
    add_column :crm_connections, :connection_type_id, :integer
    add_column :crm_connections, :health_info_id, :integer
    add_column :crm_connections, :liability_auto, :integer
    add_column :crm_connections, :liability_credit, :integer
    add_column :crm_connections, :liability_education, :integer
    add_column :crm_connections, :liability_estate_settlement, :integer
    add_column :crm_connections, :liability_mortage, :integer
    add_column :crm_connections, :liability_other, :integer
    add_column :crm_connections, :birth, :date
    add_column :crm_connections, :first_name, :string
    add_column :crm_connections, :last_name, :string
    add_column :crm_connections, :middle_name, :string
    add_column :crm_connections, :gender, :boolean
    add_column :crm_connections, :title, :string
    add_column :crm_connections, :company, :string
    add_column :crm_connections, :fax, :string
    add_column :crm_connections, :city, :string
    add_column :crm_connections, :state_id, :integer
    add_column :crm_connections, :zip, :string
  end
end
