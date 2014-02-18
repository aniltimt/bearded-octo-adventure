require "spec_helper"

describe Processing::Igo::OtherInsuranceXmlBuilder do
  let(:other_insurance_xml_builder) { Processing::Igo::OtherInsuranceXmlBuilder.new }

  let(:approved_details) { fire_double("Quoting::Quote", carrier_name: "Genworth", face_amount: 500000, policy_type: crm_policy_type) }
  let(:crm_case) { fire_double("Crm::Case", insurance_exists: insurance_exists) }
  let(:crm_case_2) { fire_double("Crm::Case", approved_details: approved_details, policy_number: "123232", effective_date: Date.new(2000, 12, 27)) }
  let(:crm_connection) { fire_double("Crm::Connection", cases: [crm_case, crm_case_2]) }
  let(:crm_policy_type) { fire_double("Crm::PolicyType", name: "Term Life") }

  describe "#add_other_insurance" do
    context "when the crm case has existing insurance case" do
      let(:insurance_exists) { true }
      let(:built_xml) { <<-XML
<Data Name="OTHINS_InforceInd">Yes</Data>
<Data Name="OTHINS_EI_CoverageAmt">500000</Data>
<Data Name="OTHINS_EI_Company__1">Genworth</Data>
<Data Name="OTHINS_EI_Policy">123232</Data>
<Data Name="OTHINS_EI_Replaced">Yes</Data>
<Data Name="OTHINS_EI_CoverageType">Term Life</Data>
<Data Name="OTHINS_EI_IssueDate">12/27/2000</Data>
                        XML
      }

      it "returns the built xml" do
        other_insurance_xml_builder.add_other_insurance(crm_case, crm_connection).should == built_xml
      end
    end

    context "when the crm case does not have existing insurance" do
      let(:insurance_exists) { false }
      let(:built_xml) { <<-XML
<Data Name="OTHINS_InforceInd">No</Data>
                        XML
      }

      it "returns the built xml" do
        other_insurance_xml_builder.add_other_insurance(crm_case, crm_connection).should == built_xml
      end
    end
  end
end
