class Crm::FinancialInfo < ActiveRecord::Base
  attr_accessible :asset_401k, :asset_home_equity, :asset_investments, :asset_pension,
  :asset_real_estate, :asset_savings, :asset_total, :bankruptcy, :bankruptcy_discharged, :income,
  :liability_auto, :liability_credit, :liability_education, :liability_estate_settlement,
  :liability_mortgage, :liability_other, :liability_total, :net_worth, :connection_id
   
  def household_income(crm_connection)
     if crm_connection.spouse and crm_connection.spouse.financial_info
      return crm_connection.try(:financial_info).income.to_i + crm_connection.spouse.try(:financial_info).income.to_i
    else
      return crm_connection.financial_info.income.to_i 
    end
  end
   
end
