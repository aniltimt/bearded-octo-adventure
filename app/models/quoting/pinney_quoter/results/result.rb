class Quoting::PinneyQuoter::Results::Result < ActiveResource::Base
  self.site = PINNEYQUOTER_SITE
  # self.table_name = 'quoting_results'
  # attr_protected  :id

  # # Fields for PinneyQuoter app's Result model:
  # attr_accessor :display, :quote_param_id, :company_name, :company_code, :errors,
  #               :product_name, :product_code, :spia_monthly_income, :spia_premium,
  #               :spia_quote_expiration, :spia_estimate_type, :spia_income_option,
  #               :spia_details, :spia_minimum_payout, :quarterly_premium,
  #               :semi_annual_premium, :selected_premium, :policy_fee, :health_category,
  #               :health_class, :am_best, :rating, :sprite

  # # Associations
  # has_one :approved_case, :foreign_key => 'approved_details_id', :class_name => "Crm::Case"
  # has_one :quoted_case, :foreign_key => 'quoted_details_id', :class_name => "Crm::Case"
  # has_one :submitted_case, :foreign_key => 'submitted_details_id', :class_name => "Crm::Case"
  # belongs_to :carrier, :class_name => "Carrier"
  # belongs_to :category, :class_name => "Quoting::TliCategoryOption"
  # belongs_to :connection, :class_name => "Crm::Connection"
  # belongs_to :health_class, :class_name => "Quoting::TliHealthClassOption"
  # belongs_to :policy_type, :class_name => "Crm::PolicyType"
  # belongs_to :premium_mode, :class_name => "Quoting::PremiumModeOption"
  # belongs_to :user, :class_name => "Usage::User"

  # # Return number of years this policy's coverage is to last
  # def duration
  #   self.category.try(:duration)
  # end

  # def carrier_name
  #   self.carrier.try(:name)
  # end
end
