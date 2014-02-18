module Processing
  class Smm
    def self.table_name_prefix
      'processing_smm_'
    end

    def schedule_url(crm_case, crm_connection)
      # AuditLogger['superior_mobile'].info "*** Web URL for E1 ScheduleNow Post: ***"
      # AuditLogger['superior_mobile'].info web_url
      web_url(params(crm_case, crm_connection))
    end

    private

    def params(crm_case, crm_connection)
      carrier = crm_case.submitted_details.try(:carrier)
      entity_id = crm_connection.ezl_join.nil? ? "11804" : "13663"
      phone_collection = [crm_connection.contact_info.home_phone_value, crm_connection.contact_info.work_phone_value, crm_connection.contact_info.cell_phone_value].reject{ |phone| phone.blank? }
      primary_phone = phone_collection.first
      secondary_phone = phone_collection.second if phone_collection.count > 1

      {
        :cid => carrier.try(:smm_id),
        :first_name => CGI.escape(crm_connection.first_name),
        :last_name => CGI.escape(crm_connection.last_name),
        :appphone => primary_phone,
        :appaltphone => secondary_phone,
        :ssn => crm_connection.ssn ? crm_connection.ssn.tr('-', '') : '',
        :addr => CGI.escape(crm_connection.contact_info.address_value),
        :city => crm_connection.contact_info.city,
        :state => state(crm_connection),
        :zip => crm_connection.contact_info.zip,
        :gender => crm_connection.health_info.gender,
        :dob => crm_connection.health_info.birth.try(:strftime, "%m/%d/%Y"),
        :crm_casenumber => crm_case.id,
        :ref => crm_case.id,
        :faceamt => crm_case.submitted_details.try(:face_amount),
        :entityid => entity_id,
        :entitytype => "2",
        :noaddtolist => crm_connection.ezl_join.nil?,
        :test => !Rails.env.production?
      }
    end

    def web_url(params)
      url = SMM_CONFIG["web_url"]
      parameter_string = params.map { |key, value| "#{key}=#{value}" }.join("&").tr(" ", "+")
      url + parameter_string
    end

    def state(crm_connection)
      crm_connection.contact_info.state.abbrev[0..1] if crm_connection.contact_info.state
    end
  end
end
