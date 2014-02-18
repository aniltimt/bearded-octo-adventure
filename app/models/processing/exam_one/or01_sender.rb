require "savon"

module Processing
  class ExamOne
    class Or01Sender
      def send_or01(payload)
        exam_one_wsdl = Savon.client(wsdl: EXAM_ONE_CONFIG["wsdl"])
        message = {"wsdl:username" => EXAM_ONE_CONFIG["username"],
                   "wsdl:password" => EXAM_ONE_CONFIG["password"],
                   "wsdl:destinationID" => "C1",
                   "wsdl:payload" => payload}

        soap_response = exam_one_wsdl.call(:deliver_exam_one_content, message: message)

        # AuditLogger["exam_one"].info("Response from E1: #{soap_response}")

        errors = []

        response_hash = soap_response.hash
        if response_code(response_hash) == "0"
          errors << response_text(response_hash)
          # AuditLogger["exam_one"].error("Return code 0 from Exam One:")
          # AuditLogger["exam_one"].error(root.elements["ResponseCodeText"].text)
        end

        errors
      end

      def response_code(response)
        response[:deliver_exam_one_content_response][:deliver_exam_one_content_result][:response_code]
      end

      def response_text(response)
        response[:deliver_exam_one_content_response][:deliver_exam_one_content_result][:response_code_text]
      end
    end
  end
end
