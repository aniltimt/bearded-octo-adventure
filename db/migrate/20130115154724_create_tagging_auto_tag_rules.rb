class CreateTaggingAutoTagRules < ActiveRecord::Migration
  def change
    create_table :tagging_auto_tag_rules do |t|
      t.integer :field_to_match_id
      t.text :liquid
      t.integer :operand
      t.integer :operator_id
      t.string :pattern
      t.integer :rule_type_id
      t.integer :tag_key_id
      t.integer :tag_key_to_match_id
      t.integer :tag_value_id
      t.timestamps
    end
  end
end
