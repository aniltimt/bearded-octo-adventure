class ReportingSearchConditions < SearchConditions

  def parse_search_param_string(params)
    params.each do |key, value|
      case key.to_s
        when "first"
          self.add("crm_connections.first_name = ?", value) unless value.blank?
        when "middle"
	      self.add("crm_connections.middle_name = ?", value) unless value.blank?   
        when "last"
	      self.add("crm_connections.last_name = ?", value) unless value.blank?
	    when "city"
	      self.add("contact_infos.city = ?", value) unless value.blank?
	    when "state"
	      self.add("states.name = ?", value) unless value.blank?
	    when "zip"
	      self.add("contact_infos.zip = ?", value) unless value.blank?
	    when "phone"
	      self.add("phones.value = ?", value) unless value.blank?
	    when "email"
	      self.add("email_addresses.value = ?", value) unless value.blank?
      end
    end
    self
  end
end