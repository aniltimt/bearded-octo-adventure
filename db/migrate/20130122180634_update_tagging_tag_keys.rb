class UpdateTaggingTagKeys < ActiveRecord::Migration
  def up
    add_column :tagging_tag_keys, :auto_tag_rule_set_id, :integer
    add_column :tagging_tag_keys, :tag_id, :integer
    add_column :tagging_tag_keys, :tag_value, :integer
    add_column :tagging_tag_keys,:owner_id, :integer
    add_column :tagging_tag_keys,:ownership_id, :integer
  end

  def down
  end
end
