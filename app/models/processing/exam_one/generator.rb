require File.expand_path("app/models/processing/exam_one/field_formatter")

module Processing
  class ExamOne
    class Generator
      include Processing::ExamOne::FieldFormatter
    end
  end
end
