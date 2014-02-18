require File.expand_path("app/models/processing/exam_one/applicant_record_part_two_generator")
require "fast_spec_helper"

describe Processing::ExamOne::ApplicantRecordPartTwoGenerator do
  let(:applicant_record_part_two_generator) { Processing::ExamOne::ApplicantRecordPartTwoGenerator.new }
  let(:crm_connection) { fire_double("Crm::Connection", contact_info: contact_info) }
  let(:contact_info) { fire_double("ContactInfo", address_value: "123 here", home_phone_value: "9165551234", work_phone_value: "9165554321", work_phone_ext: "9876", cell_phone_value: "9165550987") }

  describe "#generate" do
    it "generates a string" do
      applicant_record_part_two_generator.generate(crm_connection).should == "AN02123 here                                9165551234       9165554321       9876                          9165550987              "
    end
  end
end
