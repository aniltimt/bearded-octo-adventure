class CreateTaggingTagRuleFields < ActiveRecord::Migration
  def change
    create_table :tagging_tag_rule_fields do |t|
      t.string :name
      t.timestamps
    end
  end
end
