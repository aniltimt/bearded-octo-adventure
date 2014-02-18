require "spec_helper"

describe Processing::Igo do
  let(:igo) { Processing::Igo.new }

  describe "#post_xml" do
    let(:client_data_xml_builder) { fire_double("Processing::Igo::ClientDataXmlBuilder") }
    let(:user_data_xml_builder) { fire_double("Processing::Igo::UserDataXmlBuilder") }
    let(:session_data_xml_builder) { fire_double("Processing::Igo::SessionDataXmlBuilder") }

    let(:crm_case) { fire_double("Crm::Case", agent: agent) }
    let(:crm_connection) { fire_double("Crm::Connection") }
    let(:agent) { fire_double("Usage::User", first_name: "Tester") }

    before do
      WebMock.disable_net_connect!
      Processing::Igo::ClientDataXmlBuilder.stub(:new).and_return(client_data_xml_builder)
      Processing::Igo::UserDataXmlBuilder.stub(:new).and_return(user_data_xml_builder)
      Processing::Igo::SessionDataXmlBuilder.stub(:new).and_return(session_data_xml_builder)
      client_data_xml_builder.stub(:build_xml).with(crm_case, crm_connection).and_return("<clientdataxml/>")
      user_data_xml_builder.stub(:build_xml).with(agent).and_return("<userdataxml/>")
      session_data_xml_builder.stub(:build_xml).and_return("<sessiondataxml/>")
    end

    after do
      WebMock.allow_net_connect!
    end

    it "makes a request to the correct endpoint" do
      stub_request(:post, "http://184.106.112.25/Service1.asmx?op=getXML").
        with(:body => {"user"=>"Tester", "x"=>"<iGoApplicationData>\n<clientdataxml/><userdataxml/><sessiondataxml/></iGoApplicationData>\n"}).
        to_return(:status => 200, :body => "the response", :headers => {})
      igo.post_xml(crm_case, crm_connection).should == "the response"
    end
  end
end
