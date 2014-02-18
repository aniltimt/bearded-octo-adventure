require "savon"
require "savon/mock/spec_helper"
require File.expand_path("app/models/processing/exam_one/or01_sender")

module Processing
  class ExamOne
    describe Or01Sender do
      include Savon::SpecHelper

      let(:or01_sender) { Or01Sender.new }

      context "#send_or01" do
        let(:payload) { "payload" }
        let(:exam_one_response) do
          <<-XML
          <deliver_exam_one_content_response>
            <deliver_exam_one_content_result>
              <ResponseCode>#{response_code}</ResponseCode>
              <ResponseCodeText>LOL</ResponseCodeText>
            </deliver_exam_one_content_result>
          </deliver_exam_one_content_response>
          XML
        end
        let(:message) { {"wsdl:username" => "username",
                         "wsdl:password" => "password",
                         "wsdl:destinationID" => "C1",
                         "wsdl:payload" => payload} }

        before(:all) { savon.mock! }
        after(:all) { savon.unmock! }

        before do
          stub_const("EXAM_ONE_CONFIG", "wsdl" => "https://wssim.labone.com/services/eoservice.asmx?WSDL", "username" => "username", "password" => "password")
          savon.expects(:deliver_exam_one_content).with(message: message).returns(exam_one_response)
        end

        context "when the response code is not zero" do
          let(:response_code) { 123 }

          it "returns an empty array" do
            or01_sender.send_or01(payload).should == []
          end
        end

        context "when the response code is zero" do
          let(:response_code) { 0 }

          it "returns the error array" do
            or01_sender.send_or01(payload).should == ["LOL"]
          end
        end
      end
    end
  end
end
