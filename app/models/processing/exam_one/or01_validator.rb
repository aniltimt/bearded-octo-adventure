require "active_support/core_ext"

module Processing
  class ExamOne
    class Or01Validator
      def validate(client, policy)
        if policy.exam_one_company_code == "9000000"
          return ["This company is not supported. If you believe you received this message in error, please contact support."]
        end

        @errors = []

        validate_main_fields(client, policy)
        validate_address_home_work_fields(client)

        @errors
      end

      def validate_main_fields(client, policy)
        required_fields = {
          last_name: client.last_name,
          first_name: client.first_name,
          dob: client.dob,
          policy_type: policy.submitted_policy_type_id,
          policy_amount: policy.coverage_amount,
        }

        validate_required_fields(required_fields)
      end

      def validate_address_home_work_fields(client)
        @errors << "Missing either home/work phone, or address field" if needs_address_or_phone_information?(client)
        validate_required_fields(city: client.city, state: client.state, zip_code: client.zip_code) if needs_more_address_information?(client)
      end

      def validate_required_fields(required_fields)
        required_fields.each do |field, value|
          if value.to_s.strip == ""
            @errors << "Missing required field: #{field.to_s.humanize}"
          end
        end
      end

      def needs_address_or_phone_information?(client)
        client.address_1.blank? && client.home_phone.blank? && client.work_phone.blank?
      end

      def needs_more_address_information?(client)
        !client.address_1.blank? && client.home_phone.blank? && client.work_phone.blank?
      end
    end
  end
end
