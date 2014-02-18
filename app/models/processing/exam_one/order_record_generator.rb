require File.expand_path("app/models/processing/exam_one/generator")

module Processing
  class ExamOne
    class OrderRecordGenerator < Generator
      def generate(crm_case)
        build_string(crm_case)
      end

      private

      def build_string(crm_case)
        "OR01V01OO" +
          sender_quoteback_num(crm_case) +
          order_source(crm_case) +
          "         " +
          global_site_id +
          "00000000                                              "
      end

      def sender_quoteback_num(crm_case)
        format_field(30, crm_case.id.to_s)
      end

      def order_source(crm_case)
        format_field(20, crm_case.wholesale_app? ? "PIN2" : "PIN1")
      end

      def global_site_id
        EXAM_ONE_CONFIG["global_site_id"]
      end
    end
  end
end
