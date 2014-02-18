class Tagging::AutoTagRule < ActiveRecord::Base
   attr_accessible :auto_tag_rule_set_id, :connection_pattern_id, :tag_key_id, :tag_value_id, 
                  :use_pattern_id
                   
   # Associations
   belongs_to :auto_tag_rule_set, :class_name => "Tagging::AutoTagRuleSet"
   belongs_to :connection_pattern, :class_name => "Crm::Pattern"
   belongs_to :tag_key, :class_name => "Tagging::TagKey"
   belongs_to :tag_value, :class_name => "Tagging::TagValue"
   belongs_to :user_pattern, :class_name => "Usage::Pattern"
end
