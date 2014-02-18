class MoveNetWorthFromConnectionToFinancialInfo < ActiveRecord::Migration
  def up
    remove_column :crm_connections, :net_worth
    add_column :crm_financial_infos, :net_worth, :integer
    remove_column :crm_connections, :income
    add_column :crm_financial_infos, :income, :integer
  end

  def down
    remove_column :crm_financial_infos, :net_worth
    add_column :crm_connections, :net_worth, :integer
    remove_column :crm_financial_infos, :income
    add_column :crm_connections, :income, :integer
  end
end
