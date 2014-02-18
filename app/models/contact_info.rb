class ContactInfo < ActiveRecord::Base
  attr_accessible :city, :company, :fax, :preferred_contact_method_id,
                  :state, :state_id, :zip,  :user_attributes, :emails_attributes,
                  :phones_attributes, :addresses_attributes, :profile_attributes,
                  :preferred_contact_time

  # Pseudo-accessors
  attr_accessible :address_value, :cell_phone_value, :email_value,
                  :home_phone_value, :work_phone_ext, :work_phone_value

  liquid_methods  :city, :company, :fax, :preferred_contact_method_id,
                  :state_id, :zip,  :user_attributes, :emails_attributes,
                  :phones_attributes, :addresses_attributes
  
  has_one :user, class_name: "Usage::User"
  has_one :profile, :foreign_key => :contact_info_id, class_name: "Usage::Profile", dependent: :destroy
  has_one :crm_connection, :foreign_key => :contact_info_id, class_name: "Crm::Connection", dependent: :destroy
  has_one :crm_owner, class_name: "Crm::Owner", dependent: :destroy
  has_many :emails, class_name: "EmailAddress", dependent: :destroy
  has_many :addresses, class_name: "Address", dependent: :destroy
  has_many :phones, class_name: "Phone", dependent: :destroy
  has_many :websites, class_name: "Website", dependent: :destroy
  belongs_to :state
  belongs_to :preferred_contact_method, class_name: "Crm::ContactMethod"

  accepts_nested_attributes_for :profile, :allow_destroy => true
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :emails, :allow_destroy => true
  accepts_nested_attributes_for :phones, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :allow_destroy => true
  accepts_nested_attributes_for :websites, :allow_destroy => true
  accepts_nested_attributes_for :crm_connection, :allow_destroy => true
  accepts_nested_attributes_for :crm_owner, :allow_destroy => true

  ### Pseudo accessor/mutator methods

  # Returns value of first address or nil
  def address_value
    addresses.first.try :value
  end

  def address_value= value
    addresses.first.try(:value=, value) or
    addresses << Address.new(value:value)
  end

  def cell_phone_value
    phone_value 'cell'
  end

  def cell_phone_value= value
    phone('cell').try(:value=, value) or
    phones << Phone.new( value:value, phone_type:PhoneType.find_by_name('cell') )
  end

  def email_value
    emails.first.try :value
  end

  def email_value= value
    emails.first.try :value=, value or
    emails << EmailAddress.new(value:value)
  end

  def home_phone_value
    phone_value 'home'
  end

  def home_phone_value= value
    phone('home').try :value=, value or
    phones << Phone.new( value:value, phone_type:PhoneType.find_by_name('home') )
  end

  def phone phone_type_name=nil
    phones.joins(:phone_type).where('phone_types.name = ?', phone_type_name).first
  end

  def phone_value phone_type_name=nil
    phone(phone_type_name).try :value
  end

  def set_phone_value value, phone_type_name
    phone(phone_type_name).try :value=, value or
    phones << Phone.new( value:value, phone_type:PhoneType.find_by_name(phone_type_name) )
  end

  def work_phone_ext
    phone('work').try :ext
  end

  def work_phone_ext= ext
    phone('work').try :ext=, ext or
    phones << Phone.new( ext:ext, phone_type:PhoneType.find_by_name('work') )
  end

  def work_phone_value
    phone_value 'work'
  end

  def work_phone_value= value
    self.set_phone_value value, 'work'
  end

  def valid_quoter?
    validates_presence_of :state
    errors.empty?
  end

  #Explicit column definitions for rspec-fire
  def city; super; end
  def zip; super; end
end
