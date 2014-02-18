class Phone < ActiveRecord::Base
  attr_accessible :contact_info_id, :ext, :phone_type, :phone_type_id, :value
  belongs_to :contact_info, class_name: "ContactInfo"
  belongs_to :phone_type, class_name: "PhoneType"

  #scope for get phone by phone_type
  scope :phones_by_phone_type, lambda { |phone_type|
    joins(:phone_type).where("phone_types.name = ?", phone_type)
  }

  def to_s separator=" ext. "
    ext.nil? ? value : "#{value}#{separator}#{ext}"
  end

  def self.home_number
    phone = phones_by_phone_type('home').first
    phone.try(:ext).to_s + " " + phone.try(:value).to_s
  end

  def self.work_place_number
    phone = phones_by_phone_type('work').first
    phone.try(:ext).to_s + " " + phone.try(:value).to_s
  end

  def self.mobile_number
    phone = phones_by_phone_type('mobile').first
    phone.try(:ext).to_s + " " + phone.try(:value).to_s
  end
end
