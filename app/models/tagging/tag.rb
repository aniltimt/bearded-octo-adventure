class Tagging::Tag < ActiveRecord::Base
  attr_accessible :connection_id, :tag_value_id, :tag_type_id, :user_id, :tag_key_id,
                  :crm_connection, :tag_value, :tag_type, :user, :tag_key

  # Associations
  belongs_to :crm_connection, class_name: 'Crm::Connection', :foreign_key => :connection_id
  belongs_to :tag_key, :class_name => "Tagging::TagKey"
  belongs_to :tag_value, :class_name => "Tagging::TagValue"
  belongs_to :tag_type, :class_name => "Tagging::TagType"
  belongs_to :user, :class_name => "Usage::User"

  def self.create_from_string(string, connection)
    key, operator, value = string.partition(/\=/)
    unless key.blank?
      tag_key = Tagging::TagKey.find_or_create_by_name(key, :owner => connection.agent)

      unless value.blank?
        tag_value = Tagging::TagValue.find_or_create_by_value(value)
      end
      tag_type = Tagging::TagType.find_or_create_by_name("tracking")

      tag = Tagging::Tag.find_or_create_by_tag_key_id_and_connection_id(tag_key.id, connection.id, :tag_value => tag_value, :tag_type => tag_type)
      
      if !value.blank? && tag.tag_value.blank?
        tag.update_attributes(:tag_value_id => tag_value.id)
      end
    end
  end

  def self.create_from_kwargs args={}
    tag_key = Tagging::TagKey.find_or_create_by_name(args[:key], owner:args[:owner])
    tag_value = args[:value].nil? ? nil : Tagging::TagValue.find_or_create_by_value(args[:value])
    tag_type = Tagging::TagType.find_or_create_by_name(args[:type] || 'tracking')
    Tagging::Tag.create tag_key:tag_key, tag_value:tag_value, tag_type:tag_type, crm_connection:args[:connection], user:args[:user]
  end

  def key
    tag_key.try :name
  end

  def key= name, owner=nil
    self.tag_key = Tagging::TagKey.find_or_create_by_name name, owner:owner
  end

  def value
    tag_value.try :value
  end

  def value= value
    self.tag_value = Tagging::TagValue.find_or_create_by_value value
  end

  def to_s
    if self.tag_value.nil?
      self.tag_key.name
    else
      "#{self.tag_key.name}=#{self.tag_value.value}"
    end
  end

  scope :get_recent_tags_for_user, lambda { |user|
    joins(:tag_key).
    where("tagging_tags.user_id = ?", user.id).
    limit(5).
    order('created_at desc')}

  scope :get_system_tags_for_user, lambda { |user|
      joins(:tag_key).
      where("tagging_tags.user_id = ? and tagging_tag_keys.owner_id is null", user.id).
      limit(5).
      order('created_at desc')}

  scope :get_custom_tags_for_user, lambda { |user|
    joins(:tag_key).
    where("tagging_tags.user_id = ? and tagging_tag_keys.owner_id is not null", user.id).
    limit(5).
    order('created_at desc')}

  scope :get_recent_tags_for_connection, lambda { |connection|
    joins(:tag_key).
    where("tagging_tags.connection_id = ?", connection.id).
    limit(5).
    order('created_at desc')}

  scope :get_system_tags_for_connection, lambda { |connection|
      joins(:tag_key).
      where("tagging_tags.connection_id = ? and tagging_tag_keys.owner_id is null", connection.id).
      limit(5).
      order('created_at desc')}

  scope :get_custom_tags_for_connection, lambda { |connection|
    joins(:tag_key).
    where("tagging_tags.connection_id = ? and tagging_tag_keys.owner_id is not null", connection.id).
    limit(5).
    order('created_at desc')}

  scope :lead_types, lambda {
    joins(:tag_key)
    .joins(:tag_value)
    .where('tagging_tag_keys.name = ?','lead type')
    .where('tag_value_id is not null')
  }

end
