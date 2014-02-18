require File.expand_path("app/models/processing/exam_one/order_record_generator")
require "fast_spec_helper"

module Processing
  class ExamOne
    describe OrderRecordGenerator do
      let(:order_record_generator) { OrderRecordGenerator.new }
      let(:crm_case) { fire_double("Crm::Case", id: 42, wholesale_app?: wholesale_app) }

      before do
        stub_const("EXAM_ONE_CONFIG", "global_site_id" => "0200000620")
      end

      describe "#generate" do
        context "when the crm_case is a wholesale app" do
          let(:wholesale_app) { true }

          it "generates a string with the PIN2 order source" do
            order_record_generator.generate(crm_case).should == "OR01V01OO42                            PIN2                         020000062000000000                                              "
          end
        end

        context "when the crm_case is not a wholesale app" do
          let(:wholesale_app) { false }

          it "generates a string with the PIN1 order source" do
            order_record_generator.generate(crm_case).should == "OR01V01OO42                            PIN1                         020000062000000000                                              "
          end
        end
      end
    end
  end
end
