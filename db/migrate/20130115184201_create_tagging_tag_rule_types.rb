class CreateTaggingTagRuleTypes < ActiveRecord::Migration
  def change
    create_table :tagging_tag_rule_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
