module Processing
  class Igo
    class OtherInsuranceXmlBuilder
      def add_other_insurance(crm_case, crm_connection)
        xml = Builder::XmlMarkup.new(indent: 2, escape_attrs: true)
        xml.Data(crm_case.insurance_exists ? "Yes" : "No", Name: "OTHINS_InforceInd")
        if crm_case.insurance_exists
          other_insurance = crm_connection.cases.select { |other_case| other_case != crm_case }.first
          details = other_insurance.approved_details
          xml.Data(details.face_amount, Name: "OTHINS_EI_CoverageAmt")
          xml.Data(details.carrier_name, Name: "OTHINS_EI_Company__1")
          xml.Data(other_insurance.policy_number, Name: "OTHINS_EI_Policy")
          xml.Data("Yes", Name: "OTHINS_EI_Replaced")
          xml.Data(details.policy_type.name, Name: "OTHINS_EI_CoverageType")
          xml.Data(other_insurance.effective_date.strftime("%m/%d/%Y"), Name: "OTHINS_EI_IssueDate")
        end
        xml.target!
      end
    end
  end
end
