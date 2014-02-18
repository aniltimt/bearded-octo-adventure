class Crm::Connection < ActiveRecord::Base
  include PersonStereotype
  include TaggableStereotype
  include Crm::Accessible

  attr_accessible :active, :agent_id, :birth_state_id, :birth_country, :citizenship_id, :critical_note,
                  :dl_expiration, :dl_state_id, :dln, :email_send_failed, :employer, :full_name, :ip_address,
                  :marital_status_id, :nickname, :note, :occupation, :profile_id,
                  :priority_note, :product_type, :salutation, :spouse_id, :ssn, :suffix, :years_at_address,
                  :relationship_to_agent, :relationship_to_agent_start

  # attributes for associations
  attr_accessible :cases, :cases_attributes,
                  :children, :children_attributes,
                  :contact_info, :contact_info_attributes, :contact_info_id,
                  :financial_info, :financial_info_attributes, :financial_info_id,
                  :health_info, :health_info_attributes, :health_info_id,
                  :parent, :parent_attributes, :parent_id,
                  :primary_contact_id, :primary_contact,
                  :spouse, :spouse_attributes, :spouse_id,
                  :staff_assignment_id, :staff_assignment


  #person info
  attr_accessible :birth, :first_name, :last_name, :middle_name, :gender, :title

  # Associations
  belongs_to :agent, class_name: "Usage::User"
  belongs_to :birth_state, class_name: "State"
  belongs_to :citizenship, class_name: "Crm::Citizenship"
  belongs_to :connection_type, class_name: "Crm::ConnectionType"
  belongs_to :contact_info, class_name: "ContactInfo", dependent: :destroy
  belongs_to :dl_state, class_name: "State"
  belongs_to :financial_info, class_name: "Crm::FinancialInfo", dependent: :destroy
  belongs_to :health_info, class_name: "Crm::HealthInfo", dependent: :destroy
  belongs_to :marital_status, class_name: "MaritalStatus"
  belongs_to :parent, class_name:'Crm::Connection', foreign_key: :parent_id
  belongs_to :preferred_contact_method, class_name: "Crm::ContactMethod"
  belongs_to :primary_contact, class_name: "Crm::Connection"
  belongs_to :profile,:foreign_key => :profile_id ,class_name: "Usage::Profile"
  belongs_to :product_type, class_name: "Crm::PolicyType"
  belongs_to :spouse, class_name: "Crm::Connection"
  belongs_to :staff_assignment, class_name: "Usage::StaffAssignment", dependent: :destroy

  has_one :ezl_join, class_name: "Crm::EzlJoin"
  
  has_many :activities, class_name: "Crm::Activity"
  has_many :campaigns, class_name: "Marketing::Campaign"
  has_many :cases, class_name: "Crm::Case"
  has_many :children, class_name:"Crm::Connection", foreign_key: :parent_id
  has_many :notes, class_name: "Crm::Note"
  has_many :physicians, class_name: "Crm::Physician"
  has_many :quotes, class_name: "Quoting::Quote"
  has_many :tags, class_name: "Tagging::Tag"
  has_many :tag_keys, :class_name => "Tagging::TagKey", :through => :tags
  has_many :snail_mail_messages, class_name: "Marketing::SnailMail::Message"

  accepts_nested_attributes_for :cases, :allow_destroy => true
  accepts_nested_attributes_for :children
  accepts_nested_attributes_for :contact_info, allow_destroy: true
  accepts_nested_attributes_for :financial_info, allow_destroy: true
  accepts_nested_attributes_for :health_info, :allow_destroy => true
  accepts_nested_attributes_for :parent
  accepts_nested_attributes_for :spouse
  accepts_nested_attributes_for :tags, :allow_destroy => true

  liquid_methods :source_agency

  # Validations (ordinary)
  validates :agent_id, presence:true, numericality:true

  #scopes for contact info - emails, phones and address
  scope :get_connections_by_emails, lambda { |connection|
    emails = connection.contact_info.emails.map(&:value)
    joins(:contact_info => :emails).
    where("email_addresses.value in (?) AND crm_connections.id <> ?", emails, connection.id)}

  scope :get_connections_by_phones, lambda { |connection|
    phones = connection.contact_info.phones.map(&:value)
    joins(:contact_info => :phones).
    where("phones.value in (?) AND crm_connections.id <> ?", phones, connection.id)}

  scope :get_connections_by_addresses, lambda { |connection|
    addresses = connection.contact_info.addresses.map(&:value)
    joins(:contact_info => :addresses).
    where("addresses.value in (?) AND crm_connections.id <> ?", addresses, connection.id)}

  #scope for connections by connection type
  scope :connections_by_connection_type, lambda { |type|
    joins(:connection_type).
    where("crm_connection_types.name = ?", type)
  }

  # # Scope for join with connection and users
  # scope :agent_join_for_connection, lambda {
  #   joins(:agent).
  #   joins('LEFT JOIN `usage_ascendents_descendents` ON
  #          `usage_ascendents_descendents`.`descendent_id` = `usage_users`.`id`')
  #   }

  # # Scope editables for the models which is belongs_to connection
  # scope :editables, lambda {|arg_user|
  #   rel = agent_join_for_connection

  #   statement_string = []
  #   statement_params = []
  #   statement_string << 'crm_connections.agent_id = ?'
  #   statement_params << arg_user.id
  #   if arg_user.can_edit_descendents_resources?
  #     statement_string << '(crm_connections.agent_id = usage_ascendents_descendents.descendent_id
  #       AND usage_ascendents_descendents.ascendent_id = ?)'
  #     statement_params << arg_user.id
  #   end
  #   if arg_user.can_edit_siblings_resources?
  #     statement_string << '(crm_connections.agent_id = usage_users.id
  #       AND usage_users.parent_id = ? )'
  #     statement_params << arg_user.parent_id
  #   end
  #   if arg_user.can_edit_nephews_resources?
  #     if arg_user.can_edit_siblings_resources?
  #       statement_string << '(crm_connections.agent_id = usage_ascendents_descendents.descendent_id
  #         AND usage_ascendents_descendents.ascendent_id = ?)'
  #       statement_params << arg_user.parent_id
  #     else
  #       statement_string << '(crm_connections.agent_id = usage_ascendents_descendents.descendent_id
  #         AND usage_ascendents_descendents.ascendent_id = ? AND crm_connections.agent_id <> ?)'
  #       statement_params << arg_user.parent_id
  #       statement_params << arg_user.parent_id
  #     end
  #   end

  #   rel = rel.where(statement_string.join(' OR '), *statement_params)
  #   rel
  # }

  # # Scope viewables for the models which is belongs_to connection
  # scope :viewables, lambda {|arg_user|
  #   arg_user = Usage::User.find(arg_user) if arg_user.is_a?(Fixnum)
  #   rel = agent_join_for_connection

  #   statement_string = []
  #   statement_params = []
  #   statement_string << 'crm_connections.agent_id = ?'
  #   statement_params << arg_user.id
  #   if arg_user.can_view_descendents_resources?
  #     statement_string << '(crm_connections.agent_id = usage_ascendents_descendents.descendent_id
  #       AND usage_ascendents_descendents.ascendent_id = ?)'
  #     statement_params << arg_user.id
  #   end
  #   if arg_user.can_view_siblings_resources?
  #     statement_string << '(crm_connections.agent_id = usage_users.id
  #       AND usage_users.parent_id = ? )'
  #     statement_params << arg_user.parent_id
  #   end
  #   if arg_user.can_view_nephews_resources?
  #     if arg_user.can_view_siblings_resources?
  #       statement_string << '(crm_connections.agent_id = usage_ascendents_descendents.descendent_id
  #         AND usage_ascendents_descendents.ascendent_id = ?)'
  #       statement_params << arg_user.parent_id
  #     else
  #       statement_string << '(crm_connections.agent_id = usage_ascendents_descendents.descendent_id
  #         AND usage_ascendents_descendents.ascendent_id = ? AND crm_connections.agent_id <> ?)'
  #       statement_params << arg_user.parent_id
  #       statement_params << arg_user.parent_id
  #     end
  #   end

  #   rel = rel.where(statement_string.join(' OR '), *statement_params)
  #   rel
  # }

  # Creates pseudo accessor instance methods for this class to get and set tag values for
  # tag key names
  def self.tag_pseudo_accessors method_name, key_name=nil
    key_name ||= method_name
    # Return string for tag value
    define_method(method_name) { get_tag_value(key_name) }
    # Return id of TagValue
    define_method("#{method_name}_id") { get_tag(key_name).try(:tag_value_id) }
    # Find or create Tag, TagKey, and TagValue
    define_method("#{method_name}=") {|val| set_tag(key_name,val) }
    define_method("#{method_name}_id=") {|val| set_tag_id(key_name,val) }
  end

  tag_pseudo_accessors :lead_type, 'lead type'
  tag_pseudo_accessors :source_agency, 'source agency'

  def add_tags(*tag_strings)
    tag_strings.each do |string|
      Tagging::Tag.create_from_string(string, self)
    end
  end

  def copy_client(client)
    client.attributes.each do |key, val|
      self[key] = val if self[key].blank?
    end
    self.save!
  end

  def coverage_in_force
    cases = self.cases.where("effective_date < ?", Time.now)
    amount = 0
    cases.each do |cas|
      if cas.approved_details
        amount = cas.approved_details.face_amount
      end
    end
    amount
  end

  def coverage_submitted
    cases = self.cases.where("effective_date is null or effective_date > ?", Time.now)
    amount = 0
    cases.each do |cas|
      if cas.submitted_details
        amount = cas.submitted_details.face_amount
      end
    end
    amount
  end

  def full_name_with_address
    "#{self.full_name.to_s} (#{self.address.to_s})"
  end

  # Returns a Tag or nil
  def get_tag tag_key_name
    self.tags.joins(:tag_key).where('tagging_tag_keys.name = ?', tag_key_name).first
  end

  # Returns the value of a TagValue or nil
  def get_tag_value(key)
    get_tag(key).try(:tag_value).try(:value)
  end

  def lead_type_id
    self.lead_type.try(:id)
  end

  def related_connections
    connections = Crm::Connection.where("first_name = ? AND last_name = ? AND id <> ?",
                                          self.first_name, self.last_name, self.id)
    connections += Crm::Connection.get_connections_by_emails(self) if self.contact_info.try(:emails).present?
    connections += Crm::Connection.get_connections_by_phones(self) if self.contact_info.try(:phones).present?
    connections += Crm::Connection.get_connections_by_addresses(self) if self.contact_info.try(:addresses).present?
    connections.uniq
  end

  def set_tag(key, value=nil, type=nil)
    tag = get_tag(key)
    if tag.nil?
      Tagging::Tag.create_from_kwargs key:key, owner:self.agent, value:value, connection:self, type:type
    else
      tag.value = Tagging::TagValue.find_or_create_by_value(value)
    end
  end

  def set_tag_id(key, tag_value_id, type=nil)
    tag = get_tag(key)
    if tag.nil?
      tag_key = Tagging::TagKey.find_or_create_by_name key, owner_id:self.agent_id
      Tagging::Tag.create connection_id:self.id, tag_key_id:tag_key.id, tag_value_id:tag_value_id
    else
      tag.update_attributes tag_value_id:tag_value_id
    end
  end

  def valid_quoter?
    validates_presence_of :contact_info, :health_info, :birth
    errors[:gender] = 'must be Male or Female' unless [true, false].include? self.gender
    errors[:contact_info] = 'has errors' unless contact_info.valid_quoter? if contact_info
    errors[:health_info] = 'has errors' unless health_info.valid_quoter? if health_info
    errors.empty?
  end

  #Explicit column definitions for rspec-fire
  def priority_note; super; end
  def last_name; super; end
  def first_name; super; end
  def middle_name; super; end
  def salutation; super; end
  def suffix; super; end
  def ssn; super; end
  def marital_status_id; super; end
  def contact_method_id; super; end
  def dln; super; end
  def occupation; super; end

  pseudo_date_accessor :relationship_to_agent_start, prev: :years_of_agent_relationship

  def tag_value(type)
    Tagging::TagValue.get_by_connection_and_tag_key_name(self, type).first
  end

  #Explicit column definitions for rspec-fire
  def employer; super; end
end
