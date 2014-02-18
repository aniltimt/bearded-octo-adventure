class CreateTaggingTagRuleOperators < ActiveRecord::Migration
  def up
    execute('CREATE VIEW tagging_tag_rule_operators AS SELECT
            * FROM clu_enums.tagging_tag_rule_operators;')
  end

  def down
    execute('DROP VIEW IF EXISTS tagging_tag_rule_operators;')
  end
end
