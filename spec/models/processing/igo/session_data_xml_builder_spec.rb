require "spec_helper"

describe Processing::Igo::SessionDataXmlBuilder do
  let(:session_data_xml_builder) { Processing::Igo::SessionDataXmlBuilder.new }

  describe "#build_xml"do
    let(:built_xml) { <<-XML
<SessionData>
  <Data Name="SubmissionToken">submissiontoken</Data>
  <Data Name="ImpersonatingUser">impersonatinguser</Data>
</SessionData>
                      XML
    }

    it "returns the built xml" do
      session_data_xml_builder.build_xml.should == built_xml
    end
  end
end
