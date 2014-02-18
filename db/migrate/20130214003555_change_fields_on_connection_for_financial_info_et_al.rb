class ChangeFieldsOnConnectionForFinancialInfoEtAl < ActiveRecord::Migration
  def up
    change_table :crm_connections do |t|
      t.remove :employer, :nickname, :asset_404k, :asset_home_equity,
      :asset_investments, :asset_pension, :asset_real_estate, :asset_savings,
      :liability_auto, :liability_credit, :liability_education,
      :liability_estate_settlement
      t.remove :liability_mortage, :liability_other
      t.belongs_to :financial_info
      t.rename :saultation, :salutation
    end
    add_column :usage_users, :selected_profile_id, :integer
  end

  def down
    change_table :crm_connections do |t|
      t.string :employer, :nickname
      t.integer :asset_404k, :asset_home_equity,
      :asset_investments, :asset_pension, :asset_real_estate, :asset_savings,
      :liability_auto, :liability_credit, :liability_education,
      :liability_estate_settlement, :liability_mortage, :liability_other
      t.remove :financial_info
      t.rename :salutation, :saultation
    end
    remove_column :usage_users, :selected_profile_id
  end
end
