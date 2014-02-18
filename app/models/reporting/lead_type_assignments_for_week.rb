class Reporting::LeadTypeAssignmentsForWeek < ActiveRecord::Base
  attr_accessible :agent_id, :fri, :lead_type, :mon, :sat, :sun, :thu, :tue, :wed
end
