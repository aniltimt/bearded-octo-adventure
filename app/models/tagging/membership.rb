class Tagging::Membership < ActiveRecord::Base
  attr_accessible :custom_tags_privilege, :owner_id, :ownership_id, :ownership_name
  attr_accessor :ownership_name
  
  # Associations
  belongs_to :owner, :foreign_key => :owner_id, :class_name => "Usage::User"
  belongs_to :ownership, :class_name => "Ownership"

end
