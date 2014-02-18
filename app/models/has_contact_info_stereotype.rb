module HasContactInfoStereotype

  # Specify methods for liquid
  liquid_methods :address, :city, :email, :fax, :phone, :state, :zip, :website

  def address
    contact_info.try(:addresses).try(:first).try(:value)
  end

  def city
    contact_info.try(:city)
  end

  def email
    contact_info.try(:emails).try(:first).try(:value)
  end

  def fax
    contact_info.try(:fax)
  end

  def phone
    contact_info.try(:phones).try(:first).try(:to_s)
  end

  def state
    contact_info.try(:state)
  end

  def website
    contact_info.try(:websites).try(:first).try(:url)
  end

  def zip
    contact_info.try(:zip)
  end

  # delegations
  delegate :address_value, :email_value, :phone_value, to: :contact_info

  # This module overrides the function contact_info to build a ContactInfo if none exists
  module OverrideContactInfoAccessor
    def contact_info
      super or self.send(:contact_info=, ContactInfo::new)
    end
  end
  include OverrideContactInfoAccessor

end
