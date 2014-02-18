class CreateCrmFinancialInfos < ActiveRecord::Migration
  def change
    create_table :crm_financial_infos do |t|
      t.integer :asset_401k
      t.integer :asset_home_equity
      t.integer :asset_investments
      t.integer :asset_pension
      t.integer :asset_real_estate
      t.integer :asset_savings
      t.integer :liability_auto
      t.integer :liability_credit
      t.integer :liability_education
      t.integer :liability_estate_settlement
      t.integer :liability_mortgage
      t.integer :liability_other

      t.timestamps
    end
  end
end
