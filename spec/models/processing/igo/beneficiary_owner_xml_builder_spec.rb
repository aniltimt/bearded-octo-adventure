require "spec_helper"

describe Processing::Igo::BeneficiaryOwnerXmlBuilder do
  let(:beneficiary_owner_xml_builder) { Processing::Igo::BeneficiaryOwnerXmlBuilder.new }

  describe "#add_primary_beneficiary_xml" do
    let(:beneficiaries) { [fire_double("Crm::Beneficiary", primary: true, name: "Mike E. Smith", ssn: "123456789", relationship: "Dad", percentage: 100, birth_or_trust_date: Date.new(1982, 12, 27), trustee: "Some company")] }
    let(:crm_case) { fire_double("Crm::Case", beneficiaries: beneficiaries, owner: owner) }
    let(:owner) { fire_double("Crm::Owner", name: "Jane R. Smith", ssn: "123465798", relationship: "Mother", contact_info: owner_contact_info) }
    let(:owner_contact_info) { fire_double("Crm::ContactInfo", phone_value: "3102122010") }

    let(:built_xml) { <<-XML
<Data Name="PB_FirstName">Mike</Data>
<Data Name="PB_MiddleName">E.</Data>
<Data Name="PB_LastName">Smith</Data>
<Data Name="PB_EntityName">Some company</Data>
<Data Name="PB_DOB">12/27/1982</Data>
<Data Name="PB_RelationType">Dad</Data>
<Data Name="PB_Share">100</Data>
<Data Name="PB_SSN">123456789</Data>
<Data Name="PIOwnerInd">No</Data>
<Data Name="OWN_Ind_FirstName">Jane</Data>
<Data Name="OWN_Ind_MiddleName">R.</Data>
<Data Name="OWN_Ind_LastName">Smith</Data>
<Data Name="OWN_ Ind_PHONE">3102122010</Data>
<Data Name="OWN_Ind_SSN">123465798</Data>
<Data Name="OWN_Ind_Relationship">Mother</Data>
                      XML
    }

    it "builds the xml" do
      beneficiary_owner_xml_builder.add_beneficiary_owner_xml(crm_case).should == built_xml
    end
  end
end
