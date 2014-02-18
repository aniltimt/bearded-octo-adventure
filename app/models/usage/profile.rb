class Usage::Profile < ActiveRecord::Base

  include HasContactInfoStereotype
  include OwnedStereotype
  
  attr_accessible :logo, :name, :owner_id, :ownership_id
  # logo_file for mounting an uploader of carrierwave

  liquid_methods :name
  
  validates_presence_of :name
  
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  # Associations
  belongs_to :ownership, :foreign_key => :ownership_id, :class_name => "Ownership"
  belongs_to :owner, :foreign_key => :owner_id, :class_name => "Usage::User"
  has_and_belongs_to_many :users, :join_table => 'usage_profiles_users', :class_name => "Usage::User", :foreign_key => :profile_id
  belongs_to :contact_info
  has_one :crm_connection, :foreign_key => :profile_id,:class_name => "Crm::Connection"
  has_many :snail_mail_messages, :class_name => "Marketing::SnailMail::Message"
  
  scope :viewables, lambda { |user|
    t = Usage::Profile.arel_table
    user_and_ascendent_ids = user.ascendent_ids.uniq
    user_and_ascendent_ids << user.id
    user.profiles.where(t[:owner_id].in(user_and_ascendent_ids).or(t[:ownership_id].eq(Ownership.find_by_value('global').id)))
  }

  scope :editables, lambda { |user|
    t = Usage::Profile.arel_table
    user_and_ascendent_ids = user.ascendent_ids.uniq
    user.profiles.where(t[:owner_id].eq(user.id).or(t[:owner_id].in(user_and_ascendent_ids).and(t[:ownership_id].in(Ownership.find_by_value('user and descendents').id))).or(t[:ownership_id].eq(Ownership.find_by_value('global').id)))
  }

  #Explicit column definitions for rspec-fire
  def name; super; end
end
