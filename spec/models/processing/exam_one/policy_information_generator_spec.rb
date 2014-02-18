require "spec_helper"

shared_examples_for "generating the exam one policy information" do |expected_policy_type, expected_smoker|
  it "generates a string" do
    policy_information_generator.generate(crm_connection, crm_case).should == "PI01" + expected_policy_type + "000000010001234                        Mr. Green                                         stable " + expected_smoker + " 20130320                    "
  end
end

module Processing
  class ExamOne
    describe PolicyInformationGenerator do
      let(:policy_information_generator) { PolicyInformationGenerator.new }
      let(:crm_connection) { fire_double("Crm::Connection", health_info: health_info) }
      let(:beneficiary) { fire_double("Crm::Beneficiary", name: "Mr. Green", relationship: "stable") }
      let(:crm_case) { fire_double("Crm::Case", id: 42, primary_beneficiaries: [beneficiary], submitted_details: submitted_details, created_at: Date.new(2013, 3, 20)) }
      let(:submitted_details) { fire_double("Quoting::Quote", policy_type_id: policy_type_id, face_amount: 1000) }
      let(:health_info) { fire_double("Crm::HealthInfo", smoker: smoker) }
      let(:aw_case_data) { fire_double("Processing::AgencyWorks::CaseData", agency_works_id: 1234) }

      before do
        Processing::AgencyWorks::CaseData.stub(:where).with(case_id: 42).and_return(aw_case_data)
      end

      describe "#generate" do
        let(:policy_type_id) { 1 }
        let(:smoker) { 1 }

        it_behaves_like "generating the exam one policy information", "1 ", "N"

        context "policy_type_id 2" do
          let(:policy_type_id) { 2 }

          it_behaves_like "generating the exam one policy information", "1 ", "N"
        end

        context "policy_type_id 3" do
          let(:policy_type_id) { 3 }

          it_behaves_like "generating the exam one policy information", "1 ", "N"
        end

        context "policy_type_id 4" do
          let(:policy_type_id) { 4 }

          it_behaves_like "generating the exam one policy information", "1 ", "N"
        end

        context "policy_type_id 5" do
          let(:policy_type_id) { 5 }

          it_behaves_like "generating the exam one policy information", "1 ", "N"
        end

        context "policy_type_id 6" do
          let(:policy_type_id) { 6 }

          it_behaves_like "generating the exam one policy information", "1 ", "N"
        end

        context "policy_type_id 7" do
          let(:policy_type_id) { 7 }

          it_behaves_like "generating the exam one policy information", "1 ", "N"
        end

        context "policy_type_id 8" do
          let(:policy_type_id) { 8 }

          it_behaves_like "generating the exam one policy information", "1 ", "N"
        end

        context "policy_type_id 9" do
          let(:policy_type_id) { 9 }

          it_behaves_like "generating the exam one policy information", "1 ", "N"
        end

        context "policy_type_id 10" do
          let(:policy_type_id) { 10 }

          it_behaves_like "generating the exam one policy information", "1 ", "N"
        end

        context "policy_type_id 11" do
          let(:policy_type_id) { 11 }

          it_behaves_like "generating the exam one policy information", "0 ", "N"
        end

        context "policy_type_id anything else" do
          let(:policy_type_id) { 12 }

          it_behaves_like "generating the exam one policy information", "  ", "N"
        end

        context "smoker" do
          let(:smoker) { 0 }

          it_behaves_like "generating the exam one policy information", "1 ", "Y"
        end
      end
    end
  end
end
