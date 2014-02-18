require File.expand_path("app/models/processing/exam_one/insurance_company_information_generator")
require File.expand_path("app/models/processing/exam_one/control_code_determiner")
require "fast_spec_helper"

module Processing
  class ExamOne
    describe InsuranceCompanyInformationGenerator do
      let(:insurance_company_information_generator) { InsuranceCompanyInformationGenerator.new }
      let(:crm_case) { fire_double("Crm::Case", submitted_details: submitted_details) }
      let(:submitted_details) { fire_double("Quoting::Quote", carrier: carrier) }
      let(:carrier) { fire_double("Carrier", name: "insurance co.") }

      describe "#generate" do
        it "generates a string" do
          insurance_company_information_generator.generate(crm_case, "12345").should == "CO01PI0112345     insurance co.                                                                                                     "
        end
      end
    end
  end
end
