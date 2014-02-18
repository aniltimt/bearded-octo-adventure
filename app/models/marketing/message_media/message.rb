class Marketing::MessageMedia::Message < ActiveRecord::Base
  attr_accessible :body, :failed_attempts, :profile_id,
                  :recipient, :sender_id, :sent, :template_id

  belongs_to :template
  belongs_to :crm_connection, :class_name => "Crm::Connection", :foreign_key => :connection_id
  belongs_to :profile, :class_name => "Usage::Profile"
  belongs_to :sender, :class_name => "Usage::User"
end
