class Marketing::Email::SmtpServer < ActiveRecord::Base
  include Marketing::Email::MailServerStereotype
  include OwnedStereotype
  include EncryptDecryptData

  attr_accessible :host, :owner_id, :ownership_id, :password, :port, :ssl, :username,
                  :address, :membership_id

  attr_accessor :password
  
  # Associations
  belongs_to :membership, :class_name => "Marketing::Membership"
  belongs_to :user, :foreign_key => :owner_id,:class_name => "Usage::User"
  
  before_save :encrypt_password

  def encrypt_password
    self.crypted_password = self.encrypt_confidential_data(self.password) unless self.password.blank?
  end

  def decrypt_password
    self.decrypt_confidential_data(self.crypted_password)
  end

end
