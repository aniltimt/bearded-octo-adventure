class Reporting::Membership < ActiveRecord::Base
  attr_accessible :canned_reports_privilege, :custom_reports_privilege, :owner_id, :ownership_id, :ownership_name
  attr_accessor :ownership_name
                  
  # Associations
  belongs_to :owner, :class_name => "Usage::User"
  belongs_to :ownership, :class_name => "Ownership"
end
