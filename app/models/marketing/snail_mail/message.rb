class Marketing::SnailMail::Message < ActiveRecord::Base
  include Marketing::MessageStereotype
  
  attr_accessible :body, :failed_attempts, :profile_id, :recipient, :user_id,
    :sender_id, :sent, :template_id, :topic, :connection_id, :send_email_message

  belongs_to :template, :foreign_key => :template_id
  belongs_to :crm_connection, :foreign_key => :connectin_id, :class_name => "Crm::Connection"
  belongs_to :profile, :class_name => "Usage::Profile"
  belongs_to :sender, :class_name => "Usage::User"
  belongs_to :user, :foreign_key => :user_id,:class_name => "Usage::User"

end
