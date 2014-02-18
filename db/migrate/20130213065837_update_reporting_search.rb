class UpdateReportingSearch < ActiveRecord::Migration
  def up
    add_column :reporting_searches, :query, :text
  end

  def down
     remove_column :reporting_searches, :query
  end
end
