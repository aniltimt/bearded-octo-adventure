class Quoting::Quote < ActiveRecord::Base
  self.table_name = 'quoting_results'
  attr_protected  :id

  # paperclip
  has_attached_file :illustration, {storage: :filesystem}
  before_post_process { false }

  # Associations
  has_one :approved_case, :foreign_key => 'approved_details_id', :class_name => "Crm::Case"
  has_one :quoted_case, :foreign_key => 'quoted_details_id', :class_name => "Crm::Case"
  has_one :submitted_case, :foreign_key => 'submitted_details_id', :class_name => "Crm::Case"
  belongs_to :carrier, :class_name => "Carrier"
  belongs_to :category, :class_name => "Quoting::TliCategoryOption"
  belongs_to :crm_connection, :class_name => "Crm::Connection", :foreign_key => :connection_id
  belongs_to :health_class, :class_name => "Quoting::TliHealthClassOption"
  belongs_to :policy_type, :class_name => "Crm::PolicyType"
  belongs_to :premium_mode, :class_name => "Quoting::PremiumModeOption"
  belongs_to :user, :class_name => "Usage::User"

  ### Pseudo accessor/mutator methods

  def carrier_name
    self.carrier.try(:name)
  end

  def carrier_name= name
    self.carrier = Carrier.find_or_create_by_name name
  end

  # Returns annual premium or (12 * monthly premium)
  def computed_annual_premium
    if annual_premium.present?
      annual_premium
    elsif monthly_premium.present?
      12 * monthly_premium
    end
  end

  # Return number of years this policy's coverage is to last
  def duration
    self.category.try(:duration)
  end

  def health
    self.health_class.try(:value)
  end

  def health= value
    h_klass = Quoting::TliHealthClassOption.find_by_value(value)
    self.health_class = h_klass if h_klass.present?
  end

  def modal_premium
    premium_mode.try(:name) == 'Annual' ? annual_premium : monthly_premium
  end

  def modal_premium= value
    if premium_mode.try(:name) == 'Annual'
      self.annual_premium = value
    else
      self.monthly_premium = value
    end
  end
  
  def valid_quoter?
    validates_presence_of :category, :face_amount
    validates_numericality_of :face_amount
    errors.empty?
  end

  #Explicit column definitions for rspec-fire
  def policy_type_id; super; end
  def face_amount; super; end

  module Overrides
    def premium_mode= value
      value = Quoting::PremiumModeOption.find_by_name(value) if value.is_a? String
      super(value)
    end
  end
  include Overrides
end
