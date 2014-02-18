require File.expand_path("app/models/processing/exam_one/or01_validator")

shared_examples_for "no or01 validation errors" do
  it "returns an empty array" do
    or01_validator.validate(client, policy).should == []
  end
end

module Processing
  class ExamOne
    describe Or01Validator do
      let(:or01_validator) { Or01Validator.new }

      describe "#validate" do
        let(:client) { stub(last_name: last_name, first_name: first_name, dob: dob, address_1: address_1, home_phone: home_phone, work_phone: work_phone, city: city, state: state, zip_code: zip_code) }
        let(:policy) { stub(exam_one_company_code: exam_one_company_code, submitted_policy_type_id: submitted_policy_type_id, coverage_amount: coverage_amount) }
        let(:exam_one_company_code) { "valid" }
        let(:last_name) { "valid" }
        let(:first_name) { "valid" }
        let(:dob) { "valid" }
        let(:address_1) { "valid" }
        let(:home_phone) { "valid" }
        let(:work_phone) { "valid" }
        let(:city) { "valid" }
        let(:state) { "valid" }
        let(:zip_code) { "valid" }
        let(:submitted_policy_type_id) { 1 }
        let(:coverage_amount) { 1000 }

        context "when there are no errors" do
          it_behaves_like "no or01 validation errors"
        end

        context "when the company code is not supported" do
          let(:exam_one_company_code) { "9000000" }

          it "returns an array of errors" do
            or01_validator.validate(client, policy).should == ["This company is not supported. If you believe you received this message in error, please contact support."]
          end
        end

        context "when there is no last name" do
          let(:last_name) { nil }

          it "returns an array of errors" do
            or01_validator.validate(client, policy).should == ["Missing required field: Last name"]
          end
        end

        context "when there is no first name" do
          let(:first_name) { nil }

          it "returns an array of errors" do
            or01_validator.validate(client, policy).should == ["Missing required field: First name"]
          end
        end

        context "when there is no dob" do
          let(:dob) { nil }

          it "returns an array of errors" do
            or01_validator.validate(client, policy).should == ["Missing required field: Dob"]
          end
        end

        context "when there is no policy type" do
          let(:submitted_policy_type_id) { nil }

          it "returns an array of errors" do
            or01_validator.validate(client, policy).should == ["Missing required field: Policy type"]
          end
        end

        context "when there is no coverage amount" do
          let(:coverage_amount) { nil }

          it "returns an array of errors" do
            or01_validator.validate(client, policy).should == ["Missing required field: Policy amount"]
          end
        end

        context "address 1, home phone, work phone" do
          context "when there is no address 1, home phone, or work phone" do
            let(:address_1) { nil }
            let(:home_phone) { nil }
            let(:work_phone) { nil }

            it "returns an array of errors" do
              or01_validator.validate(client, policy).should == ["Missing either home/work phone, or address field"]
            end
          end

          context "when there is an address 1" do
            context "when there is no home or work phone" do
              let(:home_phone) { nil }
              let(:work_phone) { nil }

              context "when there is no city" do
                let(:city) { nil }

                it "returns an array of errors" do
                  or01_validator.validate(client, policy).should == ["Missing required field: City"]
                end
              end

              context "when there is no state" do
                let(:state) { nil }

                it "returns an array of errors" do
                  or01_validator.validate(client, policy).should == ["Missing required field: State"]
                end
              end

              context "when there is no zip code" do
                let(:zip_code) { nil }

                it "returns an array of errors" do
                  or01_validator.validate(client, policy).should == ["Missing required field: Zip code"]
                end
              end
            end

            context "when there is a home phone" do
              let(:work_phone) { nil }

              context "when there is no city, state, or zip code" do
                let(:city) { nil }
                let(:state) { nil }
                let(:zip_code) { nil }

                it_behaves_like "no or01 validation errors"
              end
            end

            context "when there is a work phone" do
              let(:home_phone) { nil }

              context "when there is no city, state, or zip code" do
                let(:city) { nil }
                let(:state) { nil }
                let(:zip_code) { nil }

                it_behaves_like "no or01 validation errors"
              end
            end
          end
        end
      end
    end
  end
end
