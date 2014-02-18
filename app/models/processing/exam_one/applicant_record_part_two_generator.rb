require File.expand_path("app/models/processing/exam_one")
require File.expand_path("app/models/processing/exam_one/generator")

module Processing
  class ExamOne
    class ApplicantRecordPartTwoGenerator < Generator
      def generate(crm_connection)
        contact_info = crm_connection.contact_info
        "AN02" +
          format_field(40, contact_info.address_value) +
          format_field(17, contact_info.home_phone_value, true) +
          work_phone(contact_info) +
          format_field(25) +
          format_field(17, contact_info.cell_phone_value, true) +
          format_field(7)
      end

      def work_phone(contact_info)
        format_field(17, contact_info.work_phone_value, true) +
          format_field(5, contact_info.work_phone_ext)
      end
    end
  end
end
