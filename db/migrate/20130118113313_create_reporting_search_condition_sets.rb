class CreateReportingSearchConditionSets < ActiveRecord::Migration
  def change
    create_table :reporting_search_condition_sets do |t|
      t.string :name
      t.integer :search_id

      t.timestamps
    end
  end
end
