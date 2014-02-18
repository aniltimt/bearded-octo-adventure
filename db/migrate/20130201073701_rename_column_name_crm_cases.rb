class RenameColumnNameCrmCases < ActiveRecord::Migration
  def up
    rename_column :crm_cases, :client_id, :connection_id
  end

  def down
    rename_column :crm_cases, :connection_id, :client_id
  end
end
