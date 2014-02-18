module Processing
  class ExamOne
    class ControlCodeDeterminer
      def determine_control_code(crm_case, client_state)
        control_code = find_control_code(crm_case, client_state)
        control_code.try(:control_code) if control_code
      end

      def determine_company_code(crm_case, client_state)
        control_code = find_control_code(crm_case, client_state)
        control_code.company_code if control_code
      end

      private

      def find_control_code(crm_case, client_state)
        params_to_search = {
          ez_life_profile: ezlife_profile?(crm_case),
          esign: crm_case.esign?,
          carrier: crm_case.submitted_details.try(:carrier).try(:name)
        }
        if ezlife_profile?(crm_case)
          params_to_search = merge_params_for_ezlife(params_to_search, crm_case, client_state)
        else
          params_to_search = merge_params_for_wholesale(params_to_search, crm_case, client_state)
        end

        ControlCode.where(params_to_search).first
      end

      def merge_params_for_wholesale(params, crm_case, client_state)
        params = params.merge(state: "NY") if client_state == "NY" && crm_case.submitted_details.carrier.name == "Genworth"
        params = params.merge(take_out_packet: crm_case.take_out_packet?) if ["Prudential", "Banner"].include?(crm_case.submitted_details.try(:carrier).try(:name))
        params = params.merge(esign: false) if crm_case.submitted_details.try(:carrier).try(:name) == "Metlife"
        params = params.merge(policy_type: "Disability") if crm_case.submitted_details.try(:carrier).try(:name) == "Metlife" && crm_case.submitted_details.policy_type.name == "Disability"
        params
      end

      def merge_params_for_ezlife(params, crm_case, client_state)
        if ["AVIVA", "Genworth", "JohnHancock", "Transamerica"].include?(crm_case.submitted_details.carrier.name)
          params = params.merge(state: "NY") if client_state == "NY"
        end
        if crm_case.submitted_details.carrier.name == "Assurity"
          params = params.merge(state: client_state) if ["CA", "FL"].include?(client_state)
        end
        params
      end

      def ezlife_profile?(crm_case)
        !crm_case.crm_connection.ezl_join.nil?
      end
    end
  end
end
