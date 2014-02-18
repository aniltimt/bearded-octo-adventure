class CreateUsagePatterns < ActiveRecord::Migration
  def change
    create_table :usage_patterns do |t|
      t.integer :owner_id
      t.integer :ownership_id
      t.string :field_name
      t.integer :operator_id
      t.integer :model_for_pattern_id
      t.string :value

      t.timestamps
    end
  end
end
