class CreateReportingSearchFields < ActiveRecord::Migration
  def change
    create_table :reporting_search_fields do |t|
      t.boolean :current
      t.boolean :date_range
      t.string :name
      t.string :other_enum_name
      t.string :other_enum_field
      t.boolean :text_field

      t.timestamps
    end
  end
end
