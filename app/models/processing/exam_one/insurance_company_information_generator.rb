require File.expand_path("app/models/processing/exam_one/generator")

module Processing
  class ExamOne
    class InsuranceCompanyInformationGenerator < Generator
      def generate(crm_case, company_code)
        "CO01PI01" +
          format_field(10, company_code) +
          format_field(50, crm_case.submitted_details.carrier.name) +
          format_field(64)
      end
    end
  end
end
