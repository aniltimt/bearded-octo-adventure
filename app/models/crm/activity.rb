class Crm::Activity < ActiveRecord::Base
  include Crm::BelongsToConnectionStereotype
  attr_accessible :activity_type_id, :connection_id, :description, :foreign_key, :owner_id, :status_id, :user_id, :created_at

  # Associations
  belongs_to :crm_connection, class_name: 'Crm::Connection', :foreign_key => :connection_id
  belongs_to :activity_type, :class_name => "Crm::ActivityType"
  belongs_to :status, :class_name => "Crm::ActivityStatus"
  belongs_to :user, :class_name => "Usage::User"
  belongs_to :owner, :foreign_key => :owner_id,:class_name => "Usage::User"

  # Public methods
  def call
    Marketing::Vici::Call.where(:id => self.foreign_key).first
  end

  def email
    Marketing::Email::Message.where(:id => self.foreign_key).first
  end

  def letter
    Marketing::SnailMail::Message.where(:id => self.foreign_key).first
  end

  def phone_message
    Marketing::Vici::Message.where(:id => self.foreign_key).first
  end

  def sms
    Marketing::MessageMedia::Message.where(:id => self.foreign_key).first
  end

end
