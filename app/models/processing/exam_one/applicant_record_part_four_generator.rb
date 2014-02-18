require File.expand_path("app/models/processing/exam_one")
require File.expand_path("app/models/processing/exam_one/generator")

module Processing
  class ExamOne
    class ApplicantRecordPartFourGenerator < Generator
      def generate(crm_connection)
        "AN04" +
          drivers_license_state(crm_connection) +
          format_field(22, crm_connection.dln) +
          format_field(4) +
          format_field(30, crm_connection.occupation) +
          format_field(70, crm_connection.contact_info.email_value)
      end

      private

      def drivers_license_state(crm_connection)
        state = State.find(crm_connection.dl_state.name)
        state ? format_field(2, state.abbrev) : format_field(2)
      end
    end
  end
end
