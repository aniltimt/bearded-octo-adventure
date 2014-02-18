module Processing
  class Igo
    class ClientDataXmlBuilder
      def build_xml(crm_case, crm_connection)
        xml = Builder::XmlMarkup.new(indent: 2, escape_attrs: true)
        xml.ClientData {
          xml << primary_insured_xml_builder.add_primary_insured_xml(crm_connection)
          xml << carrier_xml_builder.add_carrier_xml(crm_case)
          xml << other_insurance_xml_builder.add_other_insurance(crm_case, crm_connection)
          xml << beneficiary_owner_xml_builder.add_beneficiary_owner_xml(crm_case)
        }
      end

      private

      def beneficiary_owner_xml_builder
        @beneficiary_owner_xml_builder ||= Processing::Igo::BeneficiaryOwnerXmlBuilder.new
      end

      def carrier_xml_builder
        @carrier_xml_builder ||= Processing::Igo::CarrierXmlBuilder.new
      end

      def other_insurance_xml_builder
        @other_insurance_xml_builder ||= Processing::Igo::OtherInsuranceXmlBuilder.new
      end

      def primary_insured_xml_builder
        @primary_insured_xml_builder ||= Processing::Igo::PrimaryInsuredXmlBuilder.new
      end
    end
  end
end
