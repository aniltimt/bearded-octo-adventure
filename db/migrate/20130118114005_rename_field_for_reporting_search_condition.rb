class RenameFieldForReportingSearchCondition < ActiveRecord::Migration
  def up
    rename_column :reporting_search_conditions, :search_id, :search_condition_set_id
  end

  def down
    rename_column :reporting_search_conditions, :search_condition_set_id, :search_id
  end
end
