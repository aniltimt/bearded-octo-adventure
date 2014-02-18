class Reporting::Search < ActiveRecord::Base
  
  include OwnedStereotype
  attr_accessible :owner_id, :ownership_id, :name, :query
  
  # Associations
  has_many :search_condition_sets
  belongs_to :owner, class_name: "Usage::User"
  belongs_to :ownership, class_name: "Ownership"

end
