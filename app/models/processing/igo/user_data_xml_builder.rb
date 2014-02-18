module Processing
  class Igo
    class UserDataXmlBuilder
      def build_xml(agent)
        xml = Builder::XmlMarkup.new(indent: 2, escape_attrs: true)
        xml.UserData {
          xml.Data(agent.first_name, Name: "FirstName")
          xml.Data(agent.last_name, Name: "LastName")
          xml.Data(agent.contact_info.phone_value, Name: "Phone")

          #TODO: Is this given to us by iGo or is this just a sample value?
          xml.Data(8676309, Name: "BrokerDealerLicNum")
          #TODO: Figure out what this is?
          xml.Data("True", Name: "UpdateUserProfile")
          #TODO: Figure out what this is
          xml.Data("No Idea.", Name: "FundAvailabilityGroup")
        }
        xml.target!
      end
    end
  end
end
