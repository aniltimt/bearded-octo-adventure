require "fast_spec_helper"
require File.expand_path("app/models/processing/agency_works/note_text_extractor")

module Processing
  class AgencyWorks
    describe NoteTextExtractor do
      let(:note_text_extractor) { NoteTextExtractor.new }

      describe "#extract_note_text" do
        context "when the status is App. Submitted" do
          let(:status) { "App. Submitted" }

          it "returns 37" do
            note_text_extractor.extract_note_text(status).should == 37
          end
        end

        context "when the status is Approved" do
          let(:status) { "Approved" }

          it "returns 5" do
            note_text_extractor.extract_note_text(status).should == 5
          end
        end

        context "when the status is Approved Other than Applied" do
          let(:status) { "Approved Other than Applied" }

          it "returns 9" do
            note_text_extractor.extract_note_text(status).should == 9
          end
        end

        context "when the status is Await Funds/1035 Exchange" do
          let(:status) { "Await Funds/1035 Exchange" }

          it "returns 71" do
            note_text_extractor.extract_note_text(status).should == 71
          end
        end

        context "when the status is Declined" do
          let(:status) { "Declined" }

          it "returns 17" do
            note_text_extractor.extract_note_text(status).should == 17
          end
        end

        context "when the status is Deceased" do
          let(:status) { "Deceased" }

          it "returns 39" do
            note_text_extractor.extract_note_text(status).should == 39
          end
        end

        context "when the status is Holding" do
          let(:status) { "Holding" }

          it "returns 73" do
            note_text_extractor.extract_note_text(status).should == 73
          end
        end

        context "when the status is In Force" do
          let(:status) { "In Force" }

          it "returns 63" do
            note_text_extractor.extract_note_text(status).should == 63
          end
        end

        context "when the status is Issued - Del. Req." do
          let(:status) { "Issued - Del. Req." }

          it "returns 11" do
            note_text_extractor.extract_note_text(status).should == 11
          end
        end

        context "when the status is Not Taken" do
          let(:status) { "Not Taken" }

          it "returns 20" do
            note_text_extractor.extract_note_text(status).should == 20
          end
        end

        context "when the status is Postponed" do
          let(:status) { "Postponed" }

          it "returns 15" do
            note_text_extractor.extract_note_text(status).should == 15
          end
        end

        context "when the status is Reissued Case" do
          let(:status) { "Reissued Case" }

          it "returns 41" do
            note_text_extractor.extract_note_text(status).should == 41
          end
        end

        context "when the status is Tentative Offer" do
          let(:status) { "Tentative Offer" }

          it "returns 70" do
            note_text_extractor.extract_note_text(status).should == 70
          end
        end

        context "when the status is Rated Rejected" do
          let(:status) { "Rated Rejected" }

          it "returns 23" do
            note_text_extractor.extract_note_text(status).should == 23
          end
        end

        context "when the status is anything else" do
          let(:status) { "potato" }

          it "returns nil" do
            note_text_extractor.extract_note_text(status).should be_nil
          end
        end
      end
    end
  end
end
