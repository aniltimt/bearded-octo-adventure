class Crm::CaseRequirement < ActiveRecord::Base
  attr_accessible :name, :ordered, :recieved, :required_of, :requirement_type, :status
end
