require File.expand_path("app/models/processing/exam_one/generator")

module Processing
  class ExamOne
    class PolicyInformationGenerator < Generator
      def generate(crm_connection, crm_case)
        "PI01" +
          policy_type_id(crm_case) +
          coverage_amount(crm_case) +
          format_field(28, aw_case_id(crm_case).to_s) +
          format_field(50, crm_case.primary_beneficiaries.first.name) +
          format_field(6, crm_case.primary_beneficiaries.first.relationship) +
          " " + format_field(1, crm_connection.health_info.smoker == 0 ? "Y" : "N") + " " +
          format_field(8, crm_case.created_at.strftime("%Y%m%d")) +
          format_field(20)
      end

      private

      def policy_type_id(crm_case)
        case crm_case.submitted_details.policy_type_id
        when 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
          format_field(2, "1")
        when 11
          format_field(2, "0")
        else format_field(2)
        end
      end

      def coverage_amount(crm_case)
        format_field(11, crm_case.submitted_details.face_amount.to_s.rjust(11, "0"))
      end

      def aw_case_id(crm_case)
        Processing::AgencyWorks::CaseData.where(case_id: crm_case.id).agency_works_id
      end
    end
  end
end
