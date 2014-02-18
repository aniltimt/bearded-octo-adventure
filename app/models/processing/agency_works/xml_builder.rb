require "builder"

module Processing
  class AgencyWorks
    class XmlBuilder
      def build_request_updates
        xml = Builder::XmlMarkup.new(:indent => 2,:escape_attrs => true)
        xml.instruct!
        xml.TXLife {
          xml.UserAuthRequest {
            xml.UserLoginName(AGENCY_WORKS_CONFIG["xml_username"])
            xml.UserPswd {
              xml.CryptType
              xml.Pswd(AGENCY_WORKS_CONFIG["xml_password"])
            }
            xml.VendorApp {
              xml.VendorName("", :VendorCode => 1145)
              xml.AppName("AW")
              xml.AppVer("1.1.00")
            }
          }
          xml.TXLifeRequest {
            xml.TransRefGUID()
            xml.TransType("Holding Search", :tc => 302)
            xml.TransExeDate(Time.now.strftime("%Y-%m-%d"))
            # Using DateTime instead of Time because of the %z parameter
            xml.TransExeTime(DateTime.now.strftime("%H:%M:%S%z"))
            xml.InquiryLevel("Objects", :tc => 1)
            xml.OLife {
              xml.MaxRecords("2500")
              xml.Criteria {
                xml.ObjectType("Policy", :tc => 18)
                xml.PropertyName("AsOfDate")
                xml.PropertyValue((Time.now).strftime("%Y-%m-%d"))
                xml.Operation(:tc => 6)
              }
            }
          }
        }
        xml.target!
      end
    end
  end
end
