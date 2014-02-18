require "spec_helper"

describe Processing::Igo::PrimaryInsuredXmlBuilder do
  let(:primary_insured_xml_builder) { Processing::Igo::PrimaryInsuredXmlBuilder.new }

  describe "#add_primary_insured_xml" do
    let(:birth_state) { fire_double("State", abbrev: "PA") }
    let(:citizenship) { fire_double("Crm::Citizenship", name: "USA") }
    let(:contact_info) { fire_double("Crm::ContactInfo", address_value: "3002 trinity ct", city: "Chester Springs", email_value: "mshea@ipipeline.com", state: contact_state, zip: "19425", home_phone_value: "6102097500", work_phone_value: "6102097500", work_phone_ext: "4123") }
    let(:contact_state) { fire_double("State", abbrev: "PA") }
    let(:crm_connection) { fire_double("Crm::Connection",
                                       first_name: "Test",
                                       last_name: "User",
                                       middle_name: "E",
                                       gender: "Male",
                                       ssn: "123456789",
                                       birth: Date.new(1982, 12, 27),
                                       birth_state_id: 42,
                                       birth_country: "USA",
                                       marital_status_id: 43,
                                       dl_state_id: 44,
                                       dln: "1231232",
                                       health_info: health_info,
                                       citizenship: citizenship,
                                       employer: "ipipeline",
                                       occupation: "Director",
                                       financial_info: financial_info,
                                       contact_info: contact_info
                                      ) }
    let(:dl_state) { fire_double("State", abbrev: "PA") }
    let(:financial_info) { fire_double("Crm::FinancialInfo", income: 50000) }
    let(:health_info) { fire_double("Crm::HealthInfo", tobacco?: true, feet: 5, inches: 10, weight: 200) }
    let(:marital_status) { fire_double("MaritalStatus", name: "Married") }

    let(:built_xml) { <<-XML
<Data Name="PIFirstName">Test</Data>
<Data Name="PILastName">User</Data>
<Data Name="PIMiddleName">E</Data>
<Data Name="PIGender">Male</Data>
<Data Name="PISSN">123456789</Data>
<Data Name="PIDOB">12/27/1982</Data>
<Data Name="PIBirthState">PA</Data>
<Data Name="PIBirthCountry">USA</Data>
<Data Name="PIMStatus">Married</Data>
<Data Name="PIDLicense">PA</Data>
<Data Name="PIDLicenseNo">1231232</Data>
<Data Name="PITobaccoInfo">Yes</Data>
<Data Name="PIFNDCitizenCountry">USA</Data>
<Data Name="PICitizen">Yes</Data>
<Data Name="PIEmployed">Yes</Data>
<Data Name="PIEMP_Name">ipipeline</Data>
<Data Name="PIEMP_Occupation">Director</Data>
<Data Name="PIAnnualEarnedIncome">50000</Data>
<Data Name="MED_Q1_HtIn">10</Data>
<Data Name="MED_Q1_HtFt">5</Data>
<Data Name="MED_Q1_Wt">200</Data>
<Data Name="PIEmail">mshea@ipipeline.com</Data>
<Data Name="PIADDR_Street">3002 trinity ct</Data>
<Data Name="PIADDR_City">Chester Springs</Data>
<Data Name="PIADDR_State">PA</Data>
<Data Name="StateID">PA</Data>
<Data Name="PIADDR_Zip">19425</Data>
<Data Name="PIPhone_Home">6102097500</Data>
<Data Name="PIPhone_Work">6102097500</Data>
<Data Name="PIPhone_Work_EXT">4123</Data>
                      XML
    }

    before do
      State.stub(:find).with(42).and_return(birth_state)
      State.stub(:find).with(44).and_return(dl_state)
      MaritalStatus.stub(:find).with(43).and_return(marital_status)
    end

    it "returns the built xml" do
      primary_insured_xml_builder.add_primary_insured_xml(crm_connection).should == built_xml
    end
  end
end
