module Marketing::MessageStereotype
  include ToLiquidize
  include Crm::HasActivityStereotype

  def get_profile_for_liquid
    unless self.crm_connection.blank?
      self.crm_connection.profile
    else
      self.sender.profiles.first
    end
  end

  def get_message_content
    if self.template.present?
      message_body = self.template.apply(self.user, get_profile_for_liquid, self.crm_connection)
    elsif body.present?
      message_body = self.apply(self.user, get_profile_for_liquid, self.crm_connection)
    end
    return message_body
  end

end
