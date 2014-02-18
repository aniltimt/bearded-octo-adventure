class UpdateTaggingAutoTagRules < ActiveRecord::Migration
  def up
    remove_column :tagging_auto_tag_rules, :field_to_match_id
    remove_column :tagging_auto_tag_rules, :liquid
    remove_column :tagging_auto_tag_rules, :operand
    remove_column :tagging_auto_tag_rules, :operator_id
    remove_column :tagging_auto_tag_rules, :pattern
    remove_column :tagging_auto_tag_rules, :rule_type_id
    remove_column :tagging_auto_tag_rules, :tag_key_to_match_id
    add_column :tagging_auto_tag_rules, :auto_tag_rule_set_id, :integer
    add_column :tagging_auto_tag_rules, :connection_pattern_id, :integer
    add_column :tagging_auto_tag_rules, :user_pattern_id, :integer
  end

  def down
  end
end