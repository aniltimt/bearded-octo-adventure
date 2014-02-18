require File.expand_path("app/models/processing/exam_one/generator")

module Processing
  class ExamOne
    class OrderNotesGenerator < Generator
      def generate(crm_connection)
        crm_connection.priority_note == "" ? "" : build_string(crm_connection)
      end

      private

      def build_string(crm_connection)
        "ON01" + notes(crm_connection) + format_field(38)
      end

      def notes(crm_connection)
        format_field(90, crm_connection.priority_note)
      end
    end
  end
end
