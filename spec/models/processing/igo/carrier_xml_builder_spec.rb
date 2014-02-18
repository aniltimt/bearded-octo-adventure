require "spec_helper"

describe Processing::Igo::CarrierXmlBuilder do
  let(:carrier_xml_builder) { Processing::Igo::CarrierXmlBuilder.new }

  describe "#add_carrier_xml" do
    let(:crm_case) { fire_double("Crm::Case", quoted_details: quoted_details) }
    let(:premium_mode) { fire_double("Quoting::PremiumModeOption", name: "Annual") }
    let(:quoted_details) { fire_double("Quoting::Quote", face_amount: 1_000_000, premium_mode: premium_mode, modal_premium: 300) }

    let(:built_xml) { <<-XML
<Data Name="CarrierID">44</Data>
<Data Name="ProductID">3522</Data>
<Data Name="ProductTypeID">1</Data>
<Data Name="FaceAmount">1000000</Data>
<Data Name="POL_PaymentMethod">Annual</Data>
<Data Name="POL_PremiumAmount">300</Data>
                      XML
    }

    it "builds the xml" do
      carrier_xml_builder.add_carrier_xml(crm_case).should == built_xml
    end
  end
end
