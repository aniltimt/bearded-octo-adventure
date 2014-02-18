class Ownership < CluEnum
  self.table_name = 'ownerships'
  self.primary_key = :id
  attr_accessible :value
  has_many :profiles, :class_name => "Usage::Profile"
  has_many :marketing_email_templates, :class_name => "Marketing::Email::Template"
  has_many :marketing_snail_mail_templates, :class_name => "Marketing::SnailMail::Template"
end
