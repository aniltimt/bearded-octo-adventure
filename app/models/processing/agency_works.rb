require "savon"

module Processing
  class AgencyWorks
    class AgencyWorksSubmitError < StandardError; end

    def self.table_name_prefix
      'processing_agency_work_'
    end

    def send_to_agencyworks(xml_to_send)
      response_hash = request_agencyworks(xml_to_send)
      raise AgencyWorksSubmitError, "There was an error submitting this policy to AgencyWorks. Please contact support for assistance." if error?(response_hash)
      confirmation_id(response_hash)
    end

    def request_updates
      beginning = Time.now
      xml = xml_builder.build_request_updates
      response_hash = request_agencyworks(xml, {open_timeout: 3600, read_timeout: 3600})
      policies = extract_policies(response_hash)
      update_stats = status_updater.update_statuses(policies)
      execution_time = Time.now - beginning
      status_update_logger.log_status_updates(policies.count, update_stats, execution_time)
    end

    private

    def error?(response)
      response[:t_x_life_operation_response][:t_x_life_operation_return][:user_auth_response][:trans_result][:result_code] == "Failure"
    end

    def confirmation_id(response)
      response[:t_x_life_operation_response][:t_x_life_operation_return][:tx_life_response][:trans_result][:confirmation_id]
    end

    def extract_policies(response)
      response[:t_x_life_operation_response][:t_x_life_operation_return][:tx_life_response][:o_life][:holding][:policy]
    end

    def request_agencyworks(request_body, options = {})
      savon_options = {wsdl: AGENCY_WORKS_CONFIG["wsdl"], ssl_verify_mode: :none, ssl_version: :SSLv3}
      Savon.client(savon_options.merge(options)).call(:t_x_life_operation, message: {"TXLifeArg" => request_body}).hash
    end

    def status_update_logger
      @status_update_logger ||= Processing::AgencyWorks::StatusUpdateLogger.new
    end

    def status_updater
      @status_updater ||= Processing::AgencyWorks::StatusUpdater.new
    end

    def xml_builder
      @xml_builder ||= Processing::AgencyWorks::XmlBuilder.new
    end
  end
end

__END__
#This is a separate concern that should be dealt with elsewhere
@policy.notes.create(:user_id=>current_user.id,:title=>"Imported to AW",:body=>"This case was imported into AW on #{Time.now}",:note_type_id=>3)
@policy.imported_to_aw = true
@policy.aw_case_id = aw_case_id
@policy.save
