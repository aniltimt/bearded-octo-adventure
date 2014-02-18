class Marketing::SnailMail::Template < ActiveRecord::Base

  include Marketing::TemplateStereotype
  include OwnedStereotype
  extend LiquidFieldOptions
  
  attr_accessible :body, :owner_id, :ownership_id, :thumbnail, :name, :description, :enabled
  
  validates_presence_of :name
  
  has_attached_file :thumbnail, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  has_many :messages, :class_name => "Marketing::SnailMail::Message"

  # Associations
  belongs_to :owner, :class_name => "Usage::User"
  belongs_to :ownership, :class_name => "Ownership"
  
end
