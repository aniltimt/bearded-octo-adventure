require "spec_helper"

module Processing
  class AgencyWorks
    describe StatusUpdater do
      let(:status_updater) { StatusUpdater.new }
      let(:note_text_extractor) { fire_double("Processing::AgencyWorks::NoteTextExtractor") }

      describe "#update_statuses" do
        let(:case_data) { fire_double("Processing::AgencyWorks::CaseData", case: crm_case) }
        let(:crm_case) { fire_double("Crm::Case", status: status, statuses: [status, last_status], connection: connection) }
        let(:connection) { fire_double("Crm::Connection", ezl_join: ezl_join) }
        let(:ezl_join) { nil }
        let(:status) { fire_double("Crm::Status") }
        let(:last_status) { fire_double("Crm::Status", id: last_status_id) }
        let(:last_status_id) { 42 }
        let(:policy) { {
          policy_status: policy_status,
          application_info: {
            tracking_id: tracking_id
          }
        } }
        let(:tracking_id) { "AW_123" }
        let(:policy_status) { "status" }
        let(:note_text) { "note text" }

        before do
          Processing::AgencyWorks::NoteTextExtractor.stub(:new).and_return(note_text_extractor)
          note_text_extractor.stub(:extract_note_text).with("status").and_return(note_text)
          AgencyWorks::CaseData.stub(:find_by_agency_works_id).and_return(case_data)
          case_data.stub(:case).and_return(crm_case)
        end

        context "with a policy without a note text" do
          let(:non_failure_policy) { {
            policy_status: "status 2",
            application_info: {
              tracking_id: tracking_id
            }
          } }
          let(:note_text) { nil }

          before do
            AgencyWorks::CaseData.stub(:find_by_agency_works_id).with("123").and_return(nil)
            note_text_extractor.stub(:extract_note_text).with("status 2").and_return("legit")
          end

          it "returns a failure" do
            status_updater.update_statuses([policy, non_failure_policy])[:status_failures].should == 1
          end

          it "returns the status changes" do
            status_updater.update_statuses([policy, non_failure_policy])[:status_changes].should == 2
          end
        end

        context "when a case does not exist for the given tracking id" do
          before do
            AgencyWorks::CaseData.stub(:find_by_agency_works_id).with("123").and_return(nil)
          end

          it "returns the stats" do
            stats = status_updater.update_statuses([policy])
            stats[:status_changes].should == 1
            stats[:status_failures].should == 0
            stats[:policies_matched].should == 0
            stats[:total_cases_ready].should == 0
            stats[:successful_changes].should == 0
            stats[:ez_life_changes].should == 0
          end
        end

        context "when a case does exist for the given tracking id" do
          before do
            AgencyWorks::CaseData.stub(:find_by_agency_works_id).with("123").and_return(case_data)
            crm_case.statuses.stub(:create)
          end

          context "when the status is not nil" do
            it "creates a status" do
              crm_case.statuses.should_receive(:create).with(status_id: "note text", user_id: 1)
              status_updater.update_statuses([policy])
            end

            it "returns the stats" do
              stats = status_updater.update_statuses([policy])
              stats[:status_changes].should == 1
              stats[:status_failures].should == 0
              stats[:policies_matched].should == 1
              stats[:total_cases_ready].should == 1
              stats[:successful_changes].should == 1
              stats[:ez_life_changes].should == 0
            end

            context "when the case is an ez life case" do
              let(:ezl_join) { fire_double("Crm::EzlJoin") }

              it "returns the stats" do
                stats = status_updater.update_statuses([policy])
                stats[:status_changes].should == 1
                stats[:status_failures].should == 0
                stats[:policies_matched].should == 1
                stats[:total_cases_ready].should == 1
                stats[:successful_changes].should == 1
                stats[:ez_life_changes].should == 1
              end
            end
          end

          context "when the case status is nil" do
            let(:status) { nil }

            it "returns the stats" do
              stats = status_updater.update_statuses([policy])
              stats[:status_changes].should == 1
              stats[:status_failures].should == 0
              stats[:policies_matched].should == 1
              stats[:total_cases_ready].should == 0
              stats[:successful_changes].should == 0
              stats[:ez_life_changes].should == 0
            end
          end

          context "when the last status change id is not equal to the note text" do
            let(:note_text) { 42 }

            it "returns the stats" do
              stats = status_updater.update_statuses([policy])
              stats[:status_changes].should == 1
              stats[:status_failures].should == 0
              stats[:policies_matched].should == 1
              stats[:total_cases_ready].should == 0
              stats[:successful_changes].should == 0
              stats[:ez_life_changes].should == 0
            end
          end
        end
      end
    end
  end
end
