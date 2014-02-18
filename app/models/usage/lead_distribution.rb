class Usage::LeadDistribution < ActiveRecord::Base
  
  attr_accessible :agent_id, :count, :date
  
  # Associations
  belongs_to :agent, :foreign_key => :agent_id, :class_name => "Usage::User"
  
end
