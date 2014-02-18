class AddEffectiveDateToCrmCases < ActiveRecord::Migration
  def change
    add_column :crm_cases, :effective_date, :date
  end
end
