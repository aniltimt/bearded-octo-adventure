require File.expand_path("app/models/processing/exam_one/applicant_record_part_one_generator")
require "fast_spec_helper"

describe Processing::ExamOne::ApplicantRecordPartOneGenerator do
  let(:applicant_record_part_one_generator) { Processing::ExamOne::ApplicantRecordPartOneGenerator.new }
  let(:crm_connection) { fire_double("Crm::Connection", last_name: "potato", first_name: "test", middle_name: "sets", salutation: "Mr.", suffix: "lol", health_info: crm_health_info, ssn: "123456789", marital_status_id: marital_status_id, contact_method_id: contact_method_id) }
  let(:crm_health_info) { fire_double("Crm::HealthInfo", birth: Date.new(2013, 3, 20), gender: gender, smoker: smoker) }

  describe "#generate" do
    let(:gender) { "male" }
    let(:marital_status_id) { 1 }
    let(:contact_method_id) { 1 }
    let(:smoker) { -1 }

    it "generates a string" do
      applicant_record_part_one_generator.generate(crm_connection).should == "AN01potato                        test                sets                Mr.lol20130320123456789mSN  0    HM                       "
    end

    context "work contact method" do
      let(:contact_method_id) { 2 }

      it "uses the work contact code" do
        applicant_record_part_one_generator.generate(crm_connection).should == "AN01potato                        test                sets                Mr.lol20130320123456789mSN  0    WK                       "
      end
    end

    context "mobile contact method" do
      let(:contact_method_id) { 3 }

      it "uses the mobile contact code" do
        applicant_record_part_one_generator.generate(crm_connection).should == "AN01potato                        test                sets                Mr.lol20130320123456789mSN  0    MO                       "
      end
    end

    context "email contact method" do
      let(:contact_method_id) { 4 }

      it "uses a blank contact method" do
        applicant_record_part_one_generator.generate(crm_connection).should == "AN01potato                        test                sets                Mr.lol20130320123456789mSN  0                             "
      end
    end

    context "no contact method" do
      let(:contact_method_id) { nil }

      it "uses a blank contact method" do
        applicant_record_part_one_generator.generate(crm_connection).should == "AN01potato                        test                sets                Mr.lol20130320123456789mSN  0                             "
      end
    end

    context "no gender" do
      let(:gender) { nil }

      it "generates a string without a gender" do
        applicant_record_part_one_generator.generate(crm_connection).should == "AN01potato                        test                sets                Mr.lol20130320123456789 SN  0    HM                       "
      end
    end

    context "married marital status code" do
      let(:marital_status_id) { 2 }

      it "generates a string with the married marital status code" do
        applicant_record_part_one_generator.generate(crm_connection).should == "AN01potato                        test                sets                Mr.lol20130320123456789mMN  0    HM                       "
      end
    end

    context "divorced marital status code" do
      let(:marital_status_id) { 3 }

      it "generates a string with the divorced marital status code" do
        applicant_record_part_one_generator.generate(crm_connection).should == "AN01potato                        test                sets                Mr.lol20130320123456789mDN  0    HM                       "
      end
    end

    context "widowed marital status code" do
      let(:marital_status_id) { 4 }

      it "generates a string with the widowed marital status code" do
        marital_status_id = 4
        applicant_record_part_one_generator.generate(crm_connection).should == "AN01potato                        test                sets                Mr.lol20130320123456789mWN  0    HM                       "
      end
    end

    context "no marital status" do
      let(:marital_status_id) { nil }

      it "generates a string without a marital status code" do
        applicant_record_part_one_generator.generate(crm_connection).should == "AN01potato                        test                sets                Mr.lol20130320123456789m N  0    HM                       "
      end
    end

    context "no smoker status given" do
      let(:smoker) { nil }

      it "generates a string without a smoker status" do
        applicant_record_part_one_generator.generate(crm_connection).should == "AN01potato                        test                sets                Mr.lol20130320123456789mS   0    HM                       "
      end
    end

    context "crm_connection is a smoker" do
      let(:smoker) { 1 }

      it "generates a string without a smoker status" do
        applicant_record_part_one_generator.generate(crm_connection).should == "AN01potato                        test                sets                Mr.lol20130320123456789mSY  0    HM                       "
      end
    end
  end
end
