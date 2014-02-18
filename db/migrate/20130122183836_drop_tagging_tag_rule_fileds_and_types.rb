class DropTaggingTagRuleFiledsAndTypes < ActiveRecord::Migration
  def up
    drop_table :tagging_tag_rule_fields
    drop_table :tagging_tag_rule_types
  end

  def down
  end
end
