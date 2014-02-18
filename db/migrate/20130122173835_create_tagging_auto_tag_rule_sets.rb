class CreateTaggingAutoTagRuleSets < ActiveRecord::Migration
  def change
    create_table :tagging_auto_tag_rule_sets do |t|
      t.integer :auto_tag_rule_id
      t.string :name
      t.integer :tag_key_id
      t.integer :tag_value_id
      t.timestamps
    end
  end
end
