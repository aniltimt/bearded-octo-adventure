class AddFieldToUsageLicense < ActiveRecord::Migration
  def up
    add_column :usage_licenses, :corporate, :boolean
    add_column :usage_licenses, :effective_date, :date
  end
  
  def down
    remove_column :usage_licenses, :corporate
    remove_column :usage_licenses, :effective_date
  end
end
