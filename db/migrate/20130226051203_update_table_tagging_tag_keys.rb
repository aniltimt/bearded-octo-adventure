class UpdateTableTaggingTagKeys < ActiveRecord::Migration
  def up
    remove_column :tagging_tag_keys, :auto_tag_rule_set_id
    remove_column :tagging_tag_keys, :tag_id
    remove_column :tagging_tag_keys, :tag_value
  end

  def down
    add_column :tagging_tag_keys, :auto_tag_rule_set_id, :integer
    add_column :tagging_tag_keys, :tag_id, :integer
    add_column :tagging_tag_keys, :tag_value, :string
  end
end
