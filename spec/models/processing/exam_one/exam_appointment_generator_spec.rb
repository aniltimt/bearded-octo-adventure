require File.expand_path("app/models/processing/exam_one/exam_appointment_generator")
require "fast_spec_helper"

module Processing
  class ExamOne
    describe ExamAppointmentGenerator do
      let(:exam_appointment_generator) { ExamAppointmentGenerator.new }
      let(:crm_case) { fire_double("Crm::Case", exam_date: exam_date) }

      describe "#generate" do
        context "when the exam has been scheduled" do
          let(:exam_date) { Date.new(2013, 3, 20) }

          it "generates a string" do
            exam_appointment_generator.generate(crm_case).should == "SE0120130320000000                                                                                                                  "
          end
        end

        context "when the exam has not been scheduled" do
          let(:exam_date) { nil }

          it "generates a string" do
            exam_appointment_generator.generate(crm_case).should == "SE01                                                                                                                                "
          end
        end
      end
    end
  end
end
