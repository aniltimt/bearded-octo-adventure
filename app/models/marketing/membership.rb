class Marketing::Membership < ActiveRecord::Base
  attr_accessible :canned_template_privilege, :custom_template_privilege, :owner_id, :ownership_id, :ownership_name, :smtp_servers_attributes
  attr_accessor :ownership_name
  # Associations
  belongs_to :owner, class_name: "Usage::User"
  belongs_to :ownership, class_name: "Ownership"
  has_many :smtp_servers, :dependent => :destroy, class_name: "Marketing::Email::SmtpServer"

  accepts_nested_attributes_for :smtp_servers

  # Public Methods
  def readable_email_templates
    Marketing::Email::Template.all(self.owner)
  end

  def readable_sms_templates
    Marketing::MessageMedia::Template.all(self.owner)
  end

  def readable_letter_templates
    Marketing::SnailMail::Template.all(self.owner)
  end

  def writeable_sms_template
    self.owner.merketing_message_media_templates
  end

  def writeable_email_template
    self.owner.marketing_email_templates
  end
end
