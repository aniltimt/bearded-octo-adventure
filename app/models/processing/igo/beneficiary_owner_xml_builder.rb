module Processing
  class Igo
    class BeneficiaryOwnerXmlBuilder
      def add_beneficiary_owner_xml(crm_case)
        xml = Builder::XmlMarkup.new(indent: 2, escape_attrs: true)
        primary_beneficiary = crm_case.beneficiaries.select { |beneficiary| beneficiary.primary }.first
        pb_full_name = primary_beneficiary.name
        xml.Data(first_name(pb_full_name), Name: "PB_FirstName")
        xml.Data(middle_name(pb_full_name), Name: "PB_MiddleName")
        xml.Data(last_name(pb_full_name), Name: "PB_LastName")
        xml.Data(primary_beneficiary.trustee, Name: "PB_EntityName")
        xml.Data(primary_beneficiary.birth_or_trust_date.strftime("%m/%d/%Y"), Name: "PB_DOB")
        xml.Data(primary_beneficiary.relationship, Name: "PB_RelationType")
        xml.Data(primary_beneficiary.percentage, Name: "PB_Share")
        xml.Data(primary_beneficiary.ssn, Name: "PB_SSN")
        primary_insured_owner = crm_case.owner.nil? ? "Yes" : "No"
        xml.Data(primary_insured_owner, Name: "PIOwnerInd")
        owner = crm_case.owner
        owner_full_name = owner.name
        xml.Data(first_name(owner_full_name), Name: "OWN_Ind_FirstName")
        xml.Data(middle_name(owner_full_name), Name: "OWN_Ind_MiddleName")
        xml.Data(last_name(owner_full_name), Name: "OWN_Ind_LastName")
        xml.Data(owner.contact_info.phone_value, Name: "OWN_ Ind_PHONE")
        xml.Data(owner.ssn, Name: "OWN_Ind_SSN")
        xml.Data(owner.relationship, Name: "OWN_Ind_Relationship")
        xml.target!
      end

      private

      def first_name(full_name)
        full_name.split.first
      end

      def last_name(full_name)
        full_name.split.last
      end

      def middle_name(full_name)
        names = full_name.split
        names.size > 2 ? names.second : ""
      end
    end
  end
end
