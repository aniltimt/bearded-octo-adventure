class Marketing::Email::Template < ActiveRecord::Base
  include Marketing::TemplateStereotype
  include OwnedStereotype
  extend LiquidFieldOptions
  
  attr_accessible :body, :owner_id, :ownership_id, :subject, :thumbnail, :name, :description, :enabled
  
  validates_presence_of :name
  
  has_attached_file :thumbnail, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  # Associations
  belongs_to :owner, :class_name => "Usage::User"
  belongs_to :ownership, :class_name => "Ownership"
  
  def copy
    temp_item_attributes = self.attributes.reject{ |k,v|
      %w(created_at updated_at thumbnail_file_name thumbnail_content_type thumbnail_file_size thumbnail_updated_at).include?(k)
    }
    Marketing::Email::Template.create(temp_item_attributes)
  end
  
end
