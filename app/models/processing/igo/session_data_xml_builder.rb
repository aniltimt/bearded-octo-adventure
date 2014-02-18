module Processing
  class Igo
    class SessionDataXmlBuilder
      def build_xml
        xml = Builder::XmlMarkup.new(indent: 2, escape_attrs: true)
        xml.SessionData {
          xml.Data("submissiontoken", Name: "SubmissionToken")
          xml.Data("impersonatinguser", Name: "ImpersonatingUser")
        }
        xml.target!
      end
    end
  end
end
