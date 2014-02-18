class CreateReportingSearches < ActiveRecord::Migration
  def change
    create_table :reporting_searches do |t|
      t.integer :owner_id
      t.integer :ownership_id
      t.string :name

      t.timestamps
    end
  end
end
