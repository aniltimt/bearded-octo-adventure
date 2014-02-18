class Marketing::AutoTaskRule < ActiveRecord::Base
  attr_accessible :auto_system_task_rule_id, :campaign_id
  #attr_accessor :auto_system_task_rule_name, :campaign_name
  
  # Associations
  belongs_to :campaign
  belongs_to :auto_system_task_rule, :class_name => "Crm::AutoSystemTaskRule"
end
