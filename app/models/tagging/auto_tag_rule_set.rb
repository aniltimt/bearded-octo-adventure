class Tagging::AutoTagRuleSet < ActiveRecord::Base
  attr_accessible :name, :auto_tag_rule_id, :tag_key_id, :tag_value_id
  
  # Associations
   belongs_to :auto_tag_rule_set, :class_name => "Tagging::AutoTagRule"
   belongs_to :tag_key, :class_name => "Tagging::TagKey"
   belongs_to :tag_value, :class_name => "Tagging::TagValue"
end
