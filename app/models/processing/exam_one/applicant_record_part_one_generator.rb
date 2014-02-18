require File.expand_path("app/models/processing/exam_one")
require File.expand_path("app/models/processing/exam_one/generator")

module Processing
  class ExamOne
    class ApplicantRecordPartOneGenerator < Generator
      def generate(crm_connection)
        build_string(crm_connection)
      end

      private

      def build_string(crm_connection)
        "AN01" +
          full_name(crm_connection) +
          date_of_birth(crm_connection) +
          social_security_number(crm_connection) +
          gender(crm_connection) +
          marital_status(crm_connection) +
          smoker_status(crm_connection) +
          age(crm_connection) +
          format_field(4) + place_to_call(crm_connection) + format_field(23)
      end

      def full_name(crm_connection)
        format_field(30, crm_connection.last_name) +
          format_field(20, crm_connection.first_name) +
          format_field(20, crm_connection.middle_name) +
          format_field(3, crm_connection.salutation) +
          format_field(3, crm_connection.suffix)
      end

      def date_of_birth(crm_connection)
        crm_connection.health_info.birth.strftime("%Y%m%d")
      end

      def social_security_number(crm_connection)
        format_field(9, crm_connection.ssn, true)
      end

      def gender(crm_connection)
        crm_connection.health_info.gender ? crm_connection.health_info.gender.slice(0..0) : " "
      end

      def marital_status(crm_connection)
        case crm_connection.marital_status_id
        when 1
          "S"
        when 2
          "M"
        when 3
          "D"
        when 4
          "W"
        else
          " "
        end
      end

      def smoker_status(crm_connection)
        crm_connection.health_info.smoker ? crm_connection.health_info.smoker == -1 ? "N" : "Y" : " "
      end

      def age(crm_connection)
        ((DateTime.now - crm_connection.health_info.birth.to_datetime).to_i / 365).to_s.rjust(3)
      end

      def place_to_call(crm_connection)
        case crm_connection.contact_method_id
        when 1
          "HM"
        when 2
          "WK"
        when 3
          "MO"
        else
          "  "
        end
      end
    end
  end
end
