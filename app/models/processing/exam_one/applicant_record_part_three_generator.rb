require File.expand_path("app/models/processing/exam_one")
require File.expand_path("app/models/processing/exam_one/generator")

module Processing
  class ExamOne
    class ApplicantRecordPartThreeGenerator < Generator
      def generate(crm_connection)
        contact_info = crm_connection.contact_info
        "AN03" +
          address_two_and_three(contact_info.address_value) +
          format_field(27, contact_info.city) +
          format_field(2, contact_info.state.abbrev) +
          format_field(10, contact_info.zip) +
          format_field(9)
      end

      private

      def address_two_and_three(address_value)
        format_field(40, address_value[40..80]) +
          format_field(40, address_value[80..120])
      end
    end
  end
end
