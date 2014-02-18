class Crm::Owner < ActiveRecord::Base
  include Crm::BelongsToCaseStereotype
  include HasContactInfoStereotype

  attr_accessible :tin
  # beneficiary or owner fields
  attr_accessible :birth_or_trust_date, :genre_id, :name, :gender, :genre, :relationship,
                  :ssn, :trustee, :case_id, :contact_info_id

  attr_accessible :contact_info_attributes, :contact_info

  belongs_to :genre, class_name: "Crm::BeneficiaryOrOwnerType"
  belongs_to :case, class_name: "Crm::Case"
  belongs_to :contact_info, class_name: "ContactInfo"

  accepts_nested_attributes_for :contact_info
end
