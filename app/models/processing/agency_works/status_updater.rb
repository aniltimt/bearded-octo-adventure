module Processing
  class AgencyWorks
    class StatusUpdater
      def update_statuses(policies)
        update_stats = {
          ez_life_changes: 0,
          policies_matched: 0,
          status_changes: 0,
          status_failures: 0,
          successful_changes: 0,
          total_cases_ready: 0
        }
        policies.each do |policy|
          note_text = note_text_extractor.extract_note_text(policy[:policy_status])
          tracking_id = tracking_id(policy)
          update_stats[:status_changes] += 1
          if note_text.nil?
            update_stats[:status_failures] += 1
            next
          end
          if case_data = AgencyWorks::CaseData.find_by_agency_works_id(tracking_id)
            if crm_case = case_data.case
              update_stats[:policies_matched] += 1

              if !crm_case.status.nil? && crm_case.statuses.last.id != note_text
                update_stats[:total_cases_ready] += 1
                crm_case.statuses.create(status_id: note_text, user_id: 1)
                update_stats[:successful_changes] += 1

                if !crm_case.connection.ezl_join.nil?
                  # AuditLogger['ezlife_status_imports'].info "Importing status: #{status_change.inspect}"

                  # Ezlife site defined in relative environment files
                  # response = RestClient.post EZLIFE_STATUS_SITE, status_change.to_ezlife_xml, :content_type  => 'application/xml'
                  # AuditLogger['ezlife_status_imports'].info response
                  update_stats[:ez_life_changes] += 1
                end
              end
            end
          end
        end
        update_stats
      end

      private

      def note_text_extractor
        @note_text_extractor ||= Processing::AgencyWorks::NoteTextExtractor.new
      end

      def tracking_id(policy)
        policy[:application_info][:tracking_id].gsub("AW_", "")
      end
    end
  end
end
