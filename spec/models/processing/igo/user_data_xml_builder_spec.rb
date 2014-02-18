require "spec_helper"

describe Processing::Igo::UserDataXmlBuilder do
  let(:user_data_xml_builder) { Processing::Igo::UserDataXmlBuilder.new }

  describe "#build_xml" do
    let(:agent) { fire_double("Usage::User", contact_info: contact_info, first_name: "Dylan", last_name: "Knutson") }
    let(:contact_info) { fire_double("ContactInfo", phone_value: "18002235174") }

    let(:built_xml) { <<-XML
<UserData>
  <Data Name="FirstName">Dylan</Data>
  <Data Name="LastName">Knutson</Data>
  <Data Name="Phone">18002235174</Data>
  <Data Name="BrokerDealerLicNum">8676309</Data>
  <Data Name="UpdateUserProfile">True</Data>
  <Data Name="FundAvailabilityGroup">No Idea.</Data>
</UserData>
                      XML
    }

    it "returns the built xml" do
      user_data_xml_builder.build_xml(agent).should == built_xml
    end
  end
end
