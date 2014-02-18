require "net/http"

module Processing
	class Igo
    def post_xml(crm_case, crm_connection)
      uri = URI.parse(IGO_CONFIG["xml_web_service_url"])
      xml = build_xml(crm_case, crm_connection)
      response = Net::HTTP.post_form(uri, {"x" => xml, "user" => crm_case.agent.first_name})
      response.body
    end

    private

    def build_xml(crm_case, crm_connection)
      xml = Builder::XmlMarkup.new(indent: 2, escape_attrs: true)
      xml.iGoApplicationData {
        xml << client_data_xml_builder.build_xml(crm_case, crm_connection)
        xml << user_data_xml_builder.build_xml(crm_case.agent)
        xml << session_data_xml_builder.build_xml
      }
      xml.target!
    end

    def client_data_xml_builder
      @client_data_xml_builder ||= ClientDataXmlBuilder.new
    end

    def user_data_xml_builder
      @user_data_xml_builder ||= UserDataXmlBuilder.new
    end

    def session_data_xml_builder
      @session_data_xml_builder ||= SessionDataXmlBuilder.new
    end
	end
end
