require "spec_helper"

module Processing
  describe Smm do
    let(:smm) { Smm.new }

    describe "#schedule_url" do
      let(:crm_case) { fire_double("Crm::Case", id: 42, submitted_details: submitted_details) }
      let(:submitted_details) { fire_double("Quoting::Quote", carrier: fire_double("Carrier", smm_id: 43), face_amount: 1000) }
      let(:crm_connection) { fire_double("Crm::Connection", health_info: health_info, contact_info: contact_info, first_name: "test", last_name: "man", ssn: ssn, ezl_join: ezl_join) }
      let(:contact_info) { fire_double("ContactInfo", address_value: "123 here street", city: "hereville", zip: "12345", state: state, home_phone_value: home_phone, work_phone_value: work_phone, cell_phone_value: mobile_phone) }
      let(:health_info) { fire_double("Crm::HealthInfo", gender: "male", birth: Time.new(2013, 3, 5)) }
      let(:home_phone) { "123" }
      let(:work_phone) { "321" }
      let(:mobile_phone) { "456" }
      let(:ssn) { "123-45-6789" }
      let(:state) { fire_double("State", abbrev: "CA") }
      let(:ezl_join) { fire_double("Crm::EzlJoin") }

      before do
        stub_const("SMM_CONFIG", "web_url" => "http://test.com?")
      end

      context "when the client's state is not nil" do
        it "returns the web_url" do
          smm.schedule_url(crm_case, crm_connection).should == "http://test.com?cid=43&first_name=test&last_name=man&appphone=123&appaltphone=321&ssn=123456789&addr=123+here+street&city=hereville&state=CA&zip=12345&gender=male&dob=03/05/2013&crm_casenumber=42&ref=42&faceamt=1000&entityid=13663&entitytype=2&noaddtolist=false&test=true"
        end
      end

      context "when the client's state is nil" do
        let(:state) { nil }

        it "returns the web_url" do
          smm.schedule_url(crm_case, crm_connection).should == "http://test.com?cid=43&first_name=test&last_name=man&appphone=123&appaltphone=321&ssn=123456789&addr=123+here+street&city=hereville&state=&zip=12345&gender=male&dob=03/05/2013&crm_casenumber=42&ref=42&faceamt=1000&entityid=13663&entitytype=2&noaddtolist=false&test=true"
        end
      end

      context "when the ssn is nil" do
        let(:ssn) { nil }

        it "returns the web_url" do
          smm.schedule_url(crm_case, crm_connection).should == "http://test.com?cid=43&first_name=test&last_name=man&appphone=123&appaltphone=321&ssn=&addr=123+here+street&city=hereville&state=CA&zip=12345&gender=male&dob=03/05/2013&crm_casenumber=42&ref=42&faceamt=1000&entityid=13663&entitytype=2&noaddtolist=false&test=true"
        end
      end

      context "when it is not an ezl case" do
        let(:ezl_join) { nil }

        it "returns the web_url" do
          smm.schedule_url(crm_case, crm_connection).should == "http://test.com?cid=43&first_name=test&last_name=man&appphone=123&appaltphone=321&ssn=123456789&addr=123+here+street&city=hereville&state=CA&zip=12345&gender=male&dob=03/05/2013&crm_casenumber=42&ref=42&faceamt=1000&entityid=11804&entitytype=2&noaddtolist=true&test=true"
        end
      end

      context "when the home phone is not available but the other two are" do
        let(:home_phone) { nil }

        it "uses the work and mobile as primary/secondary phones" do
          smm.schedule_url(crm_case, crm_connection).should == "http://test.com?cid=43&first_name=test&last_name=man&appphone=321&appaltphone=456&ssn=123456789&addr=123+here+street&city=hereville&state=CA&zip=12345&gender=male&dob=03/05/2013&crm_casenumber=42&ref=42&faceamt=1000&entityid=13663&entitytype=2&noaddtolist=false&test=true"
        end
      end
    end
  end
end
