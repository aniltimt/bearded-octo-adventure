class Quoting::LtcExtraFieldSet < ActiveRecord::Base
  attr_accessible :benefit_period_id, :elimination_period, :health_id, 
                  :inflation_protection_id, :quoter_id, :shared_benefit
                  
  # Associations
  belongs_to :benefit_period, class_name: "Quoting::LtcBenefitPeriodOption"
  belongs_to :health, class_name: "Quoting::LtcHealthClassOption"
  belongs_to :inflation_protection, class_name: "Quoting::LtcInflationProtectionOption"
  belongs_to :quoter, class_name: "Quoting::Quoter"
end
