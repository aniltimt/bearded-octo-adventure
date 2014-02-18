require File.expand_path("app/models/processing/exam_one/generator")

module Processing
  class ExamOne
    class ExamAppointmentGenerator < Generator
      def generate(crm_case)
        "SE01" +
          exam_date_time(crm_case.exam_date) +
          format_field(114)
      end

      private

      def exam_date_time(date)
        if date
          date.strftime("%Y%m%d%H%M%S")
        else
          format_field(14)
        end
      end
    end
  end
end
