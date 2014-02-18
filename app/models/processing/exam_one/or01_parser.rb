require "active_support/core_ext"

module Processing
  class ExamOne
    class Or01Parser
      def parse_info(body)
        each_or01 = body.split(/OR01/)
        each_or01.each do |or01|
          lines = or01.split(/\n/)
          policy_number = parse_policy_number(lines)

          next if policy_does_not_exist?(policy_number)

          statuses = parse_statuses(lines)
          policy = find_relevant_policy(policy_number)

          status_collection = potential_statuses_to_save(statuses, policy.crm_connection.id)

          Hash[*status_collection.map {|status| [status.description, status]}.flatten].values.each do |status|
            if Status.exists?(connection_id: status.connection_id, description: status.description, completed_at: status.completed_at)
              # AuditLogger['exam_one_status_updates'].info "**SKIPPING** Already found an ExamOneStatus for client #{status.client_id} with description: #{status.description} and time completed: #{status.completed_at}"
              next
            end
            if status.save
              # AuditLogger['exam_one_status_updates'].info "Saved ExamOneStatus ID: #{status.id}"
            else
              # AuditLogger['exam_one_status_updates'].error "Problem saving ExamOneStatus. #{status.errors}"
            end
          end

          @status = nil
        end
      end

      private

      def policy_does_not_exist?(policy_number)
        # policy_number.blank? || (!Crm::Case.exists?(aw_case_id: policy_number) && !Crm::Case.exists?(policy_number))
        policy_number.blank? || !Crm::Case.exists?(policy_number)
      end

      def parse_policy_number(lines)
        policy_number = ""
        lines.each do |line|
          if policy_line?(line)
            policy_number = line[17..44].strip.to_i
            # AuditLogger['exam_one_status_updates'].info "Policy to update: #{policy_number}"
            next
          end
        end
        policy_number
      end

      def policy_line?(line)
        line[0..3].match(/PI01/)
      end

      def parse_statuses(lines)
        lines.select { |line| status_line?(line) }
      end

      def status_line?(line)
        line[0..1].match(/ST/)
      end

      def find_relevant_policy(policy_number)
        # Crm::Case.where("aw_case_id = #{policy_number} OR id = #{policy_number}").first
        Crm::Case.find(policy_number)
      end

      def potential_statuses_to_save(statuses, connection_id)
        status_collection = []
        statuses.each do |status|
          if @status.nil? || (@status.exam_one_status_id != exam_one_status_id(status))
            @status = Status.new(description: full_status_msg(status), completed_at: status[111..123], connection_id: connection_id, exam_one_status_id: exam_one_status_id(status))
            status_collection << @status
            # AuditLogger['exam_one_status_updates'].info "Status ID from ExamOne: #{exam_one_status_id}"
          else
            unless @status.description.include? full_status_msg(status)
              @status.description += full_status_msg(status)
              # AuditLogger['exam_one_status_updates'].info "Full status msg: #{@status.description}"
            end
          end
        end

        status_collection
      end

      def exam_one_status_id(status)
        status[24..33].strip.to_i
      end

      def full_status_msg(status)
        status[34..108].strip
      end

      def completed_at(status)
        status[111..123]
      end
    end
  end
end
