require "spec_helper"

describe Processing::Igo::ClientDataXmlBuilder do
  let(:client_data_xml_builder) { Processing::Igo::ClientDataXmlBuilder.new }

  describe "#build_xml" do
    let(:crm_case) { fire_double("Crm::Case") }
    let(:crm_connection) { fire_double("Crm::Connection") }
    let(:beneficiary_owner_xml_builder) { fire_double("Processing::Igo::BeneficiaryOwnerXmlBuilder") }
    let(:carrier_xml_builder) { fire_double("Processing::Igo::CarrierXmlBuilder") }
    let(:other_insurance_xml_builder) { fire_double("Processing::Igo::OtherInsuranceXmlBuilder") }
    let(:primary_insured_xml_builder) { fire_double("Processing::Igo::PrimaryInsuredXmlBuilder") }
    let(:xml) { <<-XML
<ClientData>
  <primaryinsuredxml/>
  <carrierxml/>
  <otherinsxml/>
  <beneficiaryownerxml/>
</ClientData>
                XML
    }

    before do
      Processing::Igo::BeneficiaryOwnerXmlBuilder.stub(:new).and_return(beneficiary_owner_xml_builder)
      Processing::Igo::CarrierXmlBuilder.stub(:new).and_return(carrier_xml_builder)
      Processing::Igo::PrimaryInsuredXmlBuilder.stub(:new).and_return(primary_insured_xml_builder)
      Processing::Igo::OtherInsuranceXmlBuilder.stub(:new).and_return(other_insurance_xml_builder)
      beneficiary_owner_xml_builder.stub(:add_beneficiary_owner_xml).with(crm_case).and_return("  <beneficiaryownerxml/>\n")
      carrier_xml_builder.stub(:add_carrier_xml).with(crm_case).and_return("  <carrierxml/>\n")
      other_insurance_xml_builder.stub(:add_other_insurance).with(crm_case, crm_connection).and_return("  <otherinsxml/>\n")
      primary_insured_xml_builder.stub(:add_primary_insured_xml).with(crm_connection).and_return("  <primaryinsuredxml/>\n")
    end

    it "builds the xml" do
      client_data_xml_builder.build_xml(crm_case, crm_connection).should == xml
    end
  end
end
