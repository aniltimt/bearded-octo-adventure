class Marketing::Email::Message < ActiveRecord::Base

  include Marketing::MessageStereotype

  attr_accessible :body, :failed_attempts, :profile_id, :recipient, :user_id,
    :sender_id, :sent, :subject, :template_id, :topic, :connection_id, :attachments_attributes, :send_email_message

  attr_accessor :send_email_message
  validates_presence_of :subject , :if => :check_template_id?
  validates :recipient, :email => true, :if => :check_recipient?

  def check_template_id?
    self.template_id.blank?
  end

  def check_recipient?
    !self.recipient.blank?
  end

  has_many :attachments, :class_name => "Marketing::Email::Attachment"
  belongs_to :template
  belongs_to :crm_connection, :class_name => "Crm::Connection", :foreign_key => :connection_id
  belongs_to :profile, :class_name => "Usage::Profile"
  belongs_to :sender, :class_name => "Usage::User", :foreign_key => :sender_id
  belongs_to :user, :foreign_key => :user_id,:class_name => "Usage::User"

  accepts_nested_attributes_for :attachments, :allow_destroy => true

  def send_email
    begin
      message_body = get_message_content
      # SEND EMAIL CODE HERE
      mail = UserMailer.email_message(self, message_body)
      custom = ::Mail.new(mail)
      custom.delivery_method(:smtp, self.sender.get_current_smtp_setting)
      if custom.deliver
        self.sent = Time.now
        save!
      end
    rescue Exception
    end
  end

end
