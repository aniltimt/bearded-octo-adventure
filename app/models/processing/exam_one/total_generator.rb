require File.expand_path("app/models/processing/exam_one/generator")

module Processing
  class ExamOne
    class TotalGenerator < Generator
      def generate
        "TOTL" +
          format_field(10, "1") +
          format_field(10, "10") +
          format_field(108)
      end
    end
  end
end
