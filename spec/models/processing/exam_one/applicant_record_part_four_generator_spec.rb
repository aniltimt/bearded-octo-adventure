require File.expand_path("app/models/processing/exam_one/applicant_record_part_four_generator")
require "fast_spec_helper"

describe Processing::ExamOne::ApplicantRecordPartFourGenerator do
  let(:applicant_record_part_four_generator) { Processing::ExamOne::ApplicantRecordPartFourGenerator.new }
  let(:crm_connection) { fire_double("Crm::Connection", contact_info: contact_info, dl_state: dl_state, dln: "12345", occupation: "being awesome") }
  let(:contact_info) { fire_double("ContactInfo", email_value: "test@test.com") }
  let(:dl_state) { fire_double("State", name: "California", abbrev: "CA") }

  before do
    stub_const("State", stub)
  end

  describe "#generate" do
    context "with a dl_state" do
      before do
        State.stub(:find).with("California").and_return(dl_state)
      end

      it "generates a string with the drivers license abbreviated state" do
        applicant_record_part_four_generator.generate(crm_connection).should == "AN04CA12345                     being awesome                 test@test.com                                                         "
      end
    end

    context "without a dl_state" do
      before do
        State.stub(:find).with("California").and_return(nil)
      end

      it "generates a string with the drivers license abbreviated state" do
        applicant_record_part_four_generator.generate(crm_connection).should == "AN04  12345                     being awesome                 test@test.com                                                         "
      end
    end
  end
end
