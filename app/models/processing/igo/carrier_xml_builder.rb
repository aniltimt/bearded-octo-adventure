module Processing
  class Igo
    class CarrierXmlBuilder
      def add_carrier_xml(crm_case)
        xml = Builder::XmlMarkup.new(indent: 2, escape_attrs: true)
        xml.Data("44", Name: "CarrierID")
        xml.Data("3522", Name: "ProductID")
        xml.Data("1", Name: "ProductTypeID")
        xml.Data(crm_case.quoted_details.face_amount, Name: "FaceAmount")
        xml.Data(crm_case.quoted_details.premium_mode.name, Name: "POL_PaymentMethod")
        xml.Data(crm_case.quoted_details.modal_premium, Name: "POL_PremiumAmount")
        xml.target!
      end

      private

      def carrier_product(crm_case)
      end
    end
  end
end
