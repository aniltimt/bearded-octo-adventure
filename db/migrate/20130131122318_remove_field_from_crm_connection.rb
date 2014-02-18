class RemoveFieldFromCrmConnection < ActiveRecord::Migration
  def up
    remove_column :crm_connections, :spouse_income
  end

  def down
    add_column :crm_connections, :spouse_income, :string
  end
end
