class Tagging::TagRuleOperator < CluEnum
  self.table_name = 'tagging_tag_rule_operators'
  self.primary_key = :id
  attr_accessible :name
end
