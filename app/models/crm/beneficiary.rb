class Crm::Beneficiary < ActiveRecord::Base
  include Crm::BelongsToCaseStereotype
  include EncryptDecryptData

  attr_accessor :birth_or_trust, :ssn_field

  attr_accessible :contingent, :percentage
  # beneficiary or owner fields
  attr_accessible :birth_or_trust_date, :genre_id, :name, :gender, :relationship,
                  :ssn, :trustee, :case_id, :birth_or_trust, :primary, :ssn_field

  belongs_to :case, class_name: "Crm::Case"
  belongs_to :genre, class_name: "Crm::BeneficiaryOrOwnerType", :foreign_key => :genre_id

  before_save :encrypt_ssn, :set_birth_or_trust_date_field

  def encrypt_ssn
    if !self.ssn_field.blank?
      if self.decrypt_ssn != self.ssn_field
        self.ssn = self.encrypt_confidential_data(self.ssn_field)
      end
    end
  end

  def decrypt_ssn
    self.decrypt_confidential_data(self.ssn) unless self.ssn.blank?
  end

  def primary
    not contingent
  end

  def primary= value
    self.contingent = !value
  end

  def set_birth_or_trust_date_field
    self.birth_or_trust_date = DateTime.strptime(self.birth_or_trust, "%m/%d/%Y") if !self.birth_or_trust.blank?
  end

  #Explicit column definitions for rspec-fire
  def name; super; end
  def relationship; super; end
end
