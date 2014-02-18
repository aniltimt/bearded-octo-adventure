class Crm::BeneficiaryOrOwnerType < CluEnum
  self.table_name = 'crm_beneficiary_or_owner_types'
  self.primary_key = :id
  # attr_accessible :title, :body
  has_many :owners, class_name: "Crm::Owner", :foreign_key => :genre_id
  has_many :crm_beneficiaries, class_name: "Crm::Beneficiary", :foreign_key => :genre_id
end
