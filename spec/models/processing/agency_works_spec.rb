require "fast_spec_helper"
require "savon"
require "savon/mock/spec_helper"
require File.expand_path("app/models/processing/agency_works")
require File.expand_path("app/models/processing/agency_works/xml_builder")
require File.expand_path("app/models/processing/agency_works/status_updater")
require File.expand_path("app/models/processing/agency_works/status_update_logger")

module Processing
  describe AgencyWorks do
    include Savon::SpecHelper

    let(:agency_works) { AgencyWorks.new }

    describe "#send_to_agencyworks" do
      let(:xml) { "xml" }
      let(:agency_works_response) do
        <<-XML
          <t_x_life_operation_response>
            <t_x_life_operation_return>
              <UserAuthResponse>
                <TransResult>
                  <ResultCode>#{result_code}</ResultCode>
                </TransResult>
              </UserAuthResponse>
              <TXLifeResponse>
                <TransResult>
                  <ConfirmationID>#{confirmation_id}</ConfirmationID>
                </TransResult>
              </TXLifeResponse>
            </t_x_life_operation_return>
          </t_x_life_operation_response>
        XML
      end
      let(:message) { {"TXLifeArg" => xml} }

      before(:all) { savon.mock! }
      after(:all) { savon.unmock! }

      before do
        stub_const("AGENCY_WORKS_CONFIG", "wsdl" => "https://ws2.agencyworks.com/EServices/services/StatusSession/wsdl/StatusSession.wsdl")
        savon.expects(:t_x_life_operation).with(message: message).returns(agency_works_response)
      end

      context "when the result code is a failure" do
        let(:result_code) { "Failure" }
        let(:confirmation_id) { "o noes" }

        it "raises an error" do
          expect { agency_works.send_to_agencyworks(xml) }.to raise_error(Processing::AgencyWorks::AgencyWorksSubmitError, "There was an error submitting this policy to AgencyWorks. Please contact support for assistance.")
        end
      end

      context "when the result code is successful" do
        let(:result_code) { "Success" }
        let(:confirmation_id) { 42 }

        it "returns the confirmation id" do
          agency_works.send_to_agencyworks(xml).should == "42"
        end
      end
    end

    describe "#request_updates" do
      let(:xml_builder) { fire_double("Processing::AgencyWorks::XmlBuilder") }
      let(:status_updater) { fire_double("Processing::AgencyWorks::StatusUpdater") }
      let(:status_update_logger) { fire_double("Processing::AgencyWorks::StatusUpdateLogger") }
      let(:message) { {"TXLifeArg" => "xml"} }
      let(:update_response) do
        <<-XML
          <t_x_life_operation_response>
            <t_x_life_operation_return>
              <TXLifeResponse>
                <OLife>
                  <Holding>
                    <Policy>
                      <PolicyStatus>App. Submitted</PolicyStatus>
                      <ApplicationInfo>
                        <TrackingID>AW_123</TrackingID>
                      </ApplicationInfo>
                      <AttachmentData>(lol data)</AttachmentData>
                    </Policy>
                    <Policy>
                      <PolicyStatus>Approved</PolicyStatus>
                      <ApplicationInfo>
                        <TrackingID>AW_321</TrackingID>
                      </ApplicationInfo>
                      <AttachmentData>(data lol)</AttachmentData>
                    </Policy>
                  </Holding>
                </OLife>
              </TXLifeResponse>
            </t_x_life_operation_return>
          </t_x_life_operation_response>
        XML
      end

      before do
        stub_const("AGENCY_WORKS_CONFIG", "wsdl" => "https://ws2.agencyworks.com/EServices/services/StatusSession/wsdl/StatusSession.wsdl")
        savon.expects(:t_x_life_operation).with(message: message).returns(update_response)
        Processing::AgencyWorks::XmlBuilder.stub(:new).and_return(xml_builder)
        Processing::AgencyWorks::StatusUpdater.stub(:new).and_return(status_updater)
        Processing::AgencyWorks::StatusUpdateLogger.stub(:new).and_return(status_update_logger)
        xml_builder.stub(:build_request_updates).and_return("xml")
        status_updater.stub(:update_statuses).and_return({the: "stuff"})
        status_update_logger.stub(:log_status_updates)
      end

      before(:all) { savon.mock! }
      after(:all) { savon.unmock! }

      it "builds the xml" do
        xml_builder.should_receive(:build_request_updates)
        agency_works.request_updates
      end

      it "updates the statuses" do
        expected_policies = [
          {
            policy_status: "App. Submitted",
            application_info: {tracking_id: "AW_123"},
            attachment_data: "(lol data)"
          },
          {
            policy_status: "Approved",
            application_info: {tracking_id: "AW_321"},
            attachment_data: "(data lol)"
          }
        ]
        status_updater.should_receive(:update_statuses).with(expected_policies)
        agency_works.request_updates
      end

      it "logs the status updates" do
        status_update_logger.should_receive(:log_status_updates).with(2, {the: "stuff"}, anything)
        agency_works.request_updates
      end
    end
  end
end
