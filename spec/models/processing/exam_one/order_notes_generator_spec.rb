require File.expand_path("app/models/processing/exam_one/order_notes_generator")
require "fast_spec_helper"

module Processing
  class ExamOne
    describe OrderNotesGenerator do
      let(:order_record_generator) { OrderNotesGenerator.new }
      let(:crm_connection) { fire_double("Crm::Connection", priority_note: priority_note) }

      describe "#generate" do
        context "when the priority_note is blank" do
          let(:priority_note) { "" }

          it "generates an empty string" do
            order_record_generator.generate(crm_connection).should == ""
          end
        end

        context "when the priority_note is not blank" do
          let(:priority_note) { "notes lol" }

          it "generates a string with the crm_connection's priority note in it" do
            order_record_generator.generate(crm_connection).should == "ON01notes lol                                                                                                                       "
          end
        end
      end
    end
  end
end
