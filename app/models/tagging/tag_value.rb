class Tagging::TagValue < ActiveRecord::Base
  attr_accessible :value

  validates :value, uniqueness:true

  scope :get_by_connection_and_tag_key_name, lambda { |connection, key_name|
    joins(:tags => [:crm_connection, :tag_key]).
    where("tagging_tags.connection_id = ? AND tagging_tag_keys.name = ?", connection.id, key_name)}

  # Associations
  has_many :lead_distribution_weights, :foreign_key => :tag_value_id, :class_name => "Usage::LeadDistributionWeight"

  has_many :tags, :class_name => "Tagging::Tag"
  has_many :tag_keys, :through => :tags

end
