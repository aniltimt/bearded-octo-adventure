class AddBankruptcyFieldsToCrmFinancialInfos < ActiveRecord::Migration
  def change
    add_column :crm_financial_infos, :bankruptcy, :date
    add_column :crm_financial_infos, :bankruptcy_discharged, :date
  end
end
