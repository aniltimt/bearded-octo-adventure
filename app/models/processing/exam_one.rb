require "active_support/core_ext"
require "net/ftp"

module Processing
  class ExamOne
    class CompanyNotSupportedError < StandardError; end
    class InvalidInformationError < StandardError; end
    class Or01SendError < StandardError; end

    def self.table_name_prefix
      "processing_exam_one_"
    end

    def build_and_send_or01(crm_connection, crm_case)
      send_or01(build_or01(crm_connection, crm_case))
    end

    def schedule_url(crm_connection, crm_case)
      web_url = EXAM_ONE_CONFIG["web_url"]

      control_code = control_code_determiner.determine_control_code(crm_case, client_state(crm_connection))

      # raise CompanyNotSupportedError, "This company is not supported. If you believe you received this message in error, please contact support." if control_code.blank?

      params = {
        control_code: control_code,
        control_num: crm_case.id,
        fname: CGI.escape(crm_connection.first_name),
        lname: CGI.escape(crm_connection.last_name),
        addr: CGI.escape(crm_connection.contact_info.address_value),
        city: crm_connection.contact_info.city,
        state: client_state(crm_connection),
        zip: Rails.env.production? ? crm_connection.contact_info.zip : 99999,
        gender: crm_connection.health_info.gender == "Male" ? 0 : 1,
        email: crm_connection.contact_info.email_value
      }

      web_url += build_parameter_string(params)
    end

    def get_statuses
      ftp = setup_ftp
      delete_done_files(ftp, time_ago_to_delete) if Rails.env.production?

      decrypt_and_save_files(ftp)
      delete_local_old_files
      # rescue Exception => exception
      #   AuditLogger['exam_one_status_updates'].error "There was an error processing exam one statuses: #{exception.message}"
    end

    private

    def build_parameter_string(params)
      parameter_string = params.map { |key, value| "#{key}=#{value}" }.join("&").tr(" ", "+")
    end

    def client_state(crm_connection)
      crm_connection.contact_info.state.abbrev[0..1] if crm_connection.contact_info.state
    end

    def decrypt_and_save_files(ftp)
      files = ftp.nlst("*.PGP")
      files.each do |filename|
        ftp.getbinaryfile(filename, full_file_path(filename))
        decrypt_file(ftp, filename)

        file_body = File.open(full_file_out_path(filename)) { |file| file.read }
        or01_parser.parse_info(file_body)
        ftp.rename(filename, "#{filename}.DONE") if Rails.env.production?
      end
    end

    def decrypt_file(ftp, filename)
      %x[echo "#{EXAM_ONE_CONFIG['passphrase']}" | gpg --passphrase-fd 0 --batch --decrypt --output "#{full_file_out_path(filename)}" "#{full_file_path(filename)}"]
    end

    def time_ago_to_delete
      (Time.now - 1.month).strftime("%Y%m%d")
    end

    def full_file_path(filename)
      "#{Rails.root}/tmp/#{filename}"
    end

    def full_file_out_path(filename)
      "#{Rails.root}/tmp/#{filename}.out"
    end

    def setup_ftp
      ftp = Net::FTP.new("xfer.labone.com")
      ftp.login("pinney", "YbjV8dl1")
      ftp.passive = true
      ftp.chdir("outgoing")
      ftp
    end

    def delete_done_files(ftp, time_ago_to_delete)
      files_to_delete = ftp.nlst("#{time_ago_to_delete}*.DONE")
      files_to_delete.each do | filename |
        ftp.delete(filename)
      end
    end

    def delete_local_old_files
      filepath = "#{Rails.root}/tmp/#{time_ago_to_delete}"
      if Rails.env.development?
        %x[del #{filepath}*.PGP]
        %x[del #{filepath}*.out]
      else
        %x[rm -f #{filepath}*.PGP]
        %x[rm -f #{filepath}*.out]
      end
    end

    def build_or01(crm_connection, crm_case)
      validate_information(crm_connection, crm_case)
      or01 = []
      or01 << order_record_generator.generate(crm_case)
      or01 << order_notes_generator.generate(crm_connection)
      or01 << applicant_record_part_one_generator.generate(crm_connection)
      or01 << applicant_record_part_two_generator.generate(crm_connection)
      or01 << applicant_record_part_three_generator.generate(crm_connection)
      or01 << applicant_record_part_four_generator.generate(crm_connection)
      company_code = control_code_determiner.determine_company_code(crm_case, client_state(crm_connection))
      or01 << insurance_company_information_generator.generate(crm_case, company_code)
      or01 << policy_information_generator.generate(crm_connection, crm_case)
      or01 << exam_appointment_generator.generate(crm_case)
      or01 << total_generator.generate
      or01.join("\n")
    end

    def send_or01(payload)
      errors = or01_sender.send_or01(payload)
      raise Or01SendError, errors.join(", ") if errors.any?
    end

    def validate_information(crm_connection, crm_case)
      errors = or01_validator.validate(crm_connection, crm_case)
      raise InvalidInformationError, errors.join(", ") if errors.any?
    end

    def order_record_generator
      @order_record_generator ||= OrderRecordGenerator.new
    end

    def order_notes_generator
      @order_notes_generator ||= OrderNotesGenerator.new
    end

    def applicant_record_part_one_generator
      @applicant_record_part_one_generator ||= ApplicantRecordPartOneGenerator.new
    end

    def applicant_record_part_two_generator
      @applicant_record_part_two_generator ||= ApplicantRecordPartTwoGenerator.new
    end

    def applicant_record_part_three_generator
      @applicant_record_part_three_generator ||= ApplicantRecordPartThreeGenerator.new
    end

    def applicant_record_part_four_generator
      @applicant_record_part_four_generator ||= ApplicantRecordPartFourGenerator.new
    end

    def insurance_company_information_generator
      @insurance_company_information_generator ||= InsuranceCompanyInformationGenerator.new
    end

    def policy_information_generator
      @policy_information_generator ||= PolicyInformationGenerator.new
    end

    def exam_appointment_generator
      @exam_appointment_generator ||= ExamAppointmentGenerator.new
    end

    def total_generator
      @total_generator ||= TotalGenerator.new
    end

    def or01_validator
      @or01_validator ||= Or01Validator.new
    end

    def or01_sender
      @or01_sender ||= Or01Sender.new
    end

    def or01_parser
      @or01_parser ||= Or01Parser.new
    end

    def control_code_determiner
      @control_code_determiner ||= ControlCodeDeterminer.new
    end
  end
end
