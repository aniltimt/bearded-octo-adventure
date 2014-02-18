require "spec_helper"
require "timecop"

module Processing
  class AgencyWorks
    describe XmlBuilder do
      let(:xml_builder) { XmlBuilder.new }

      before do
        stub_const("AGENCY_WORKS_CONFIG", "xml_username" => "username", "xml_password" => "password")
      end

      it "builds xml" do
        # Freezing at 3/5/2013 for some reason puts us at 3/4/2013 12:00am +0100
        Timecop.freeze(2013, 3, 5) do
          xml = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<TXLife>
  <UserAuthRequest>
    <UserLoginName>username</UserLoginName>
    <UserPswd>
      <CryptType/>
      <Pswd>password</Pswd>
    </UserPswd>
    <VendorApp>
      <VendorName VendorCode="1145"></VendorName>
      <AppName>AW</AppName>
      <AppVer>1.1.00</AppVer>
    </VendorApp>
  </UserAuthRequest>
  <TXLifeRequest>
    <TransRefGUID/>
    <TransType tc="302">Holding Search</TransType>
    <TransExeDate>2013-03-04</TransExeDate>
    <TransExeTime>00:00:00+0100</TransExeTime>
    <InquiryLevel tc="1">Objects</InquiryLevel>
    <OLife>
      <MaxRecords>2500</MaxRecords>
      <Criteria>
        <ObjectType tc="18">Policy</ObjectType>
        <PropertyName>AsOfDate</PropertyName>
        <PropertyValue>2013-03-04</PropertyValue>
        <Operation tc="6"/>
      </Criteria>
    </OLife>
  </TXLifeRequest>
</TXLife>
          XML
          xml_builder.build_request_updates.should == xml
        end
      end
    end
  end
end
