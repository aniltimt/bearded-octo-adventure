class Crm::HealthInfo < ActiveRecord::Base

  include HealthInfoStereotype
  include Crm::HasOneConnectionStereotype

  # for Generic
  attr_accessible :birth, :feet, :gender, :inches, :weight, :connection_id
  # for Tobacco
  attr_accessible :cigarettes_per_month, :cigars_per_month, :last_cigar, :last_cigarette,
                  :last_nicotine_patch_or_gum, :last_pipe, :last_tobacco_chewed,
                  :smoker
  # for Blood pressure & cholesterol
  attr_accessible :bp_systolic, :bp_diastolic, :bp_control_start, :cholesterol, :cholesterol_control_start,
                  :cholesterol_hdl, :last_bp_treatment, :last_cholesterol_treatment
  # for Driving history
  attr_accessible :last_dl_suspension, :last_dui_dwi, :last_reckless_driving, :penultimate_car_accident
  # for Associations
  attr_accessible :family_diseases_attributes,
                  :health_history_attributes, :health_history, :health_history_id,
                  :moving_violation_history_attributes, :moving_violation_history
  attr_accessible :criminal, :hazardous_avocation

  # Associations
  belongs_to :health_history, class_name: "Crm::HealthHistory", dependent: :destroy
  belongs_to :moving_violation_history, class_name: "Crm::MovingViolationHistory", dependent: :destroy
  has_one :crm_connection, class_name: "Crm::Connection"
  has_many :family_diseases, class_name: "Quoting::RelativesDisease", dependent: :destroy, foreign_key: :health_info_id

  accepts_nested_attributes_for :family_diseases, :allow_destroy => true
  accepts_nested_attributes_for :health_history, :allow_destroy => true
  accepts_nested_attributes_for :moving_violation_history, :allow_destroy => true

  def bp?
    last_bp_treatment.present?
  end

  def cholesterol?
    last_cholesterol_treatment.present?
  end

  def complete?
    return true
  end

  def driving_history?
    last_dl_suspension.present? or \
    (penultimate_car_accident.present? and years_since_penultimate_car_accident <= 5) or \
    moving_violation_history.try(:more_than_one?)
  end

  def tobacco?
    [:cigarettes_per_month, :cigars_per_month, :last_cigar, :last_cigarette,
    :last_nicotine_patch_or_gum, :last_pipe, :last_tobacco_chewed,
    :smoker].any?{|field| self.send(field) }
  end

  def valid_quoter?
    validates_presence_of :feet, :inches, :weight
    errors.empty?
  end

  #
  # Pseudo-accessors and pseudo-mutators
  #

  pseudo_date_accessor :bp_control_start,           prev:'years_of_bp_control'
  pseudo_date_accessor :cholesterol_control_start,  prev:'years_of_cholesterol_control'
  pseudo_date_accessor :last_bp_treatment,          prev:'years_since_bp_treatment'
  pseudo_date_accessor :last_cholesterol_treatment, prev:'years_since_cholesterol_treatment'
  pseudo_date_accessor :last_cigar,                 prev:'years_since_last_cigar'
  pseudo_date_accessor :last_cigarette,             prev:'years_since_last_cigarette'
  pseudo_date_accessor :last_dl_suspension,         prev:'years_since_dl_suspension'
  pseudo_date_accessor :last_dui_dwi,               prev:'years_since_dui_dwi'
  pseudo_date_accessor :last_nicotine_patch_or_gum, prev:'years_since_last_nicotine_patch_or_gum'
  pseudo_date_accessor :last_pipe,                  prev:'years_since_last_pipe'
  pseudo_date_accessor :last_reckless_driving,      prev:'years_since_reckless_driving'
  pseudo_date_accessor :last_tobacco_chewed,        prev:'years_since_last_tobacco_chewed'
  pseudo_date_accessor :penultimate_car_accident,   prev:'years_since_penultimate_car_accident'


  #Explicit column definitions for rspec-fire
  def gender; super; end
  def smoker; super; end
  def birth; super; end
end
