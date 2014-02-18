class CreateReportingSearchConditions < ActiveRecord::Migration
  def change
    create_table :reporting_search_conditions do |t|
      t.boolean :current
      t.date :date_max
      t.date :date_min
      t.integer :search_field_id
      t.integer :search_id
      t.string :text

      t.timestamps
    end
  end
end
