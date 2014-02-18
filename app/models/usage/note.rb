class Usage::Note < ActiveRecord::Base
  attr_accessible :body, :creator_id, :user_id, :user
  
  validates_presence_of :body, :user
  # Association
  belongs_to :user, :class_name => "Usage::User"
  belongs_to :creator, :foreign_key => :creator_id, :class_name => "Usage::User"
  
end
