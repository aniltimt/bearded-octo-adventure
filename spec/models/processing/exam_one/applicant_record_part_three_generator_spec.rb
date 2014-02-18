require File.expand_path("app/models/processing/exam_one/applicant_record_part_three_generator")
require "fast_spec_helper"

describe Processing::ExamOne::ApplicantRecordPartThreeGenerator do
  let(:applicant_record_part_three_generator) { Processing::ExamOne::ApplicantRecordPartThreeGenerator.new }
  let(:crm_connection) { fire_double("Crm::Connection", contact_info: contact_info) }
  let(:address_value) { "address 1                               address 2                               address 3" }
  let(:contact_info) { fire_double("ContactInfo", address_value: address_value, state: state, city: "hereville", zip: "12345") }
  let(:state) { fire_double("State", abbrev: "CA") }


  describe "#generate" do
    it "generates a string" do
      applicant_record_part_three_generator.generate(crm_connection).should == "AN03address 2                               address 3                               hereville                  CA12345              "
    end
  end
end
