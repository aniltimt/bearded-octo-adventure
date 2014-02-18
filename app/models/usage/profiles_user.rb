class Usage::ProfilesUser < ActiveRecord::Base

  belongs_to :profile , :class_name => "Usage::Profile"
  belongs_to :user , :class_name => "Usage::User"
  attr_accessible :profile_id, :user_id
  
end
