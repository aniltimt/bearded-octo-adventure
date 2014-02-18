class Usage::AgentFieldSet < ActiveRecord::Base
  attr_accessible :premium_limit, :temporary_suspension, :tz_max, :tz_min, :aml_id

  # Associations
  has_one :user
  has_many :licenses
  has_many :contracts
  belongs_to :aml, :class_name => "Usage::Aml"
end
