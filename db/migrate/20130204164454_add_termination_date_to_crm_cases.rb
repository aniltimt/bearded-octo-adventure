class AddTerminationDateToCrmCases < ActiveRecord::Migration
  def change
    add_column :crm_cases, :termination_date, :date
  end
end
