module Processing
  class Igo
    class PrimaryInsuredXmlBuilder
      def add_primary_insured_xml(crm_connection)
        xml = Builder::XmlMarkup.new(indent: 2, escape_attrs: true)
        xml.Data(crm_connection.first_name, Name: "PIFirstName")
        xml.Data(crm_connection.last_name, Name: "PILastName")
        xml.Data(crm_connection.middle_name, Name: "PIMiddleName")
        xml.Data(crm_connection.gender, Name: "PIGender")
        xml.Data(crm_connection.ssn, Name: "PISSN")
        xml.Data(crm_connection.birth.strftime("%m/%d/%Y"), Name: "PIDOB")
        xml.Data(birth_state(crm_connection.birth_state_id), Name: "PIBirthState")
        xml.Data(crm_connection.birth_country, Name: "PIBirthCountry")
        xml.Data(marital_status(crm_connection.marital_status_id), Name: "PIMStatus")
        xml.Data(dlicense_state(crm_connection.dl_state_id), Name: "PIDLicense")
        xml.Data(crm_connection.dln, Name: "PIDLicenseNo")
        xml.Data(crm_connection.health_info.tobacco? ? "Yes" : "No", Name: "PITobaccoInfo")
        xml.Data(crm_connection.citizenship.name, Name: "PIFNDCitizenCountry")
        xml.Data("Yes", Name: "PICitizen")
        xml.Data(crm_connection.employer.nil? ? "No" : "Yes", Name: "PIEmployed")
        xml.Data(crm_connection.employer, Name: "PIEMP_Name")
        xml.Data(crm_connection.occupation, Name: "PIEMP_Occupation")
        xml.Data(crm_connection.financial_info.income, Name: "PIAnnualEarnedIncome")
        health_info = crm_connection.health_info
        xml.Data(health_info.inches, Name: "MED_Q1_HtIn")
        xml.Data(health_info.feet, Name: "MED_Q1_HtFt")
        xml.Data(health_info.weight, Name: "MED_Q1_Wt")
        contact_info = crm_connection.contact_info
        xml.Data(contact_info.email_value, Name: "PIEmail")
        xml.Data(contact_info.address_value, Name: "PIADDR_Street")
        xml.Data(contact_info.city, Name: "PIADDR_City")
        xml.Data(contact_info.state.abbrev, Name: "PIADDR_State")
        xml.Data(contact_info.state.abbrev, Name: "StateID")
        xml.Data(contact_info.zip, Name: "PIADDR_Zip")
        xml.Data(contact_info.home_phone_value, Name: "PIPhone_Home")
        xml.Data(contact_info.work_phone_value, Name: "PIPhone_Work")
        xml.Data(contact_info.work_phone_ext, Name: "PIPhone_Work_EXT")
      end

      private

      def birth_state(state_id)
        State.find(state_id).abbrev
      end

      def marital_status(marital_status_id)
        MaritalStatus.find(marital_status_id).name
      end

      def dlicense_state(state_id)
        State.find(state_id).abbrev
      end
    end
  end
end
