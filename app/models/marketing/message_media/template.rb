class Marketing::MessageMedia::Template < ActiveRecord::Base

  include Marketing::TemplateStereotype
  include OwnedStereotype
  extend LiquidFieldOptions

  attr_accessible :body, :owner_id, :ownership_id

  # Associations
  belongs_to :owner, :class_name => "Usage::User"
  belongs_to :ownership, :class_name => "Ownership"
end
