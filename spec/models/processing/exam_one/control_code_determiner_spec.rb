require "spec_helper"

shared_examples_for "return values for control_code_determiner" do
  context "when the control code is found" do
    before do
      Processing::ExamOne::ControlCode.stub(:where).and_return([control_code])
    end

    it "returns the control code" do
      control_code_determiner.determine_control_code(crm_case, client_state).should == 1234
    end
  end

  context "when the control code is not found" do
    before do
      Processing::ExamOne::ControlCode.stub(:where).and_return([])
    end

    it "returns nil" do
      control_code_determiner.determine_control_code(crm_case, client_state).should == nil
    end
  end
end

shared_examples_for "AVIVA, Genworth, JohnHancock, Transamerica that is an ez_life_profile" do
  context "when the client state is NY" do
    let(:client_state) { "NY" }

    it_behaves_like "return values for control_code_determiner"

    it "searches using the state" do
      Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: true, esign: true, carrier: carrier_name, state: "NY")
      control_code_determiner.determine_control_code(crm_case, client_state)
    end
  end

  context "when the client state is not NY" do
    let(:client_state) { "CA" }

    it_behaves_like "return values for control_code_determiner"

    it "does not search using the state" do
      Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: true, esign: true, carrier: carrier_name)
      control_code_determiner.determine_control_code(crm_case, client_state)
    end
  end
end

shared_examples_for "Banner or Prudential crm_case not an ez_life_profile" do
  context "when the crm_case is esign" do
    let(:esign) { true }

    it_behaves_like "return values for control_code_determiner"

    it "searches using the take out packet" do
      Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: false, esign: true, carrier: carrier_name, take_out_packet: true)
      control_code_determiner.determine_control_code(crm_case, client_state)
    end
  end

  context "when the crm_case is not esign" do
    let(:esign) { false }

    it_behaves_like "return values for control_code_determiner"

    it "searches using the take out packet" do
      Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: false, esign: false, carrier: carrier_name, take_out_packet: true)
      control_code_determiner.determine_control_code(crm_case, client_state)
    end
  end
end

module Processing
  class ExamOne
    describe ControlCodeDeterminer do
      let(:control_code_determiner) { ControlCodeDeterminer.new }
      let(:crm_case) { fire_double("Crm::Case", crm_connection: crm_connection, submitted_details: submitted_details, esign?: esign, take_out_packet?: true) }
      let(:crm_connection) { fire_double("Crm::Connection", ezl_join: ezl_join) }
      let(:submitted_details) { fire_double("Quoting::Quote", carrier: carrier, policy_type: policy_type) }
      let(:carrier) { fire_double("Carrier", name: carrier_name) }
      let(:control_code) { fire_double("Processing::ExamOne::ControlCode", control_code: 1234, company_code: "ABCD") }
      let(:policy_type) { fire_double("Crm::PolicyType", name: policy_type_name) }
      let(:policy_type_name) { nil }

      before do
        Processing::ExamOne::ControlCode.stub(:where).and_return([control_code])
      end

      describe "#determine_control_code" do
        context "when the crm_case has an ezl_join" do
          let(:ezl_join) { fire_double("Crm::EzlJoin") }
          let(:esign) { true }

          context "when the carrier is Assurity" do
            let(:carrier_name) { "Assurity" }

            context "when the client state is CA" do
              let(:client_state) { "CA" }

              it_behaves_like "return values for control_code_determiner"

              it "searches using the state" do
                Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: true, esign: true, carrier: "Assurity", state: "CA")
                control_code_determiner.determine_control_code(crm_case, client_state)
              end
            end

            context "when the client state is FL" do
              let(:client_state) { "FL" }

              it_behaves_like "return values for control_code_determiner"

              it "searches using the state" do
                Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: true, esign: true, carrier: "Assurity", state: "FL")
                control_code_determiner.determine_control_code(crm_case, client_state)
              end
            end

            context "when the client state is none of the above" do
              let(:client_state) { "potato" }

              it_behaves_like "return values for control_code_determiner"

              it "does not search using the state" do
                Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: true, esign: true, carrier: "Assurity")
                control_code_determiner.determine_control_code(crm_case, client_state)
              end
            end
          end

          context "when the carrier is AVIVA" do
            let(:carrier_name) { "AVIVA" }

            it_behaves_like "AVIVA, Genworth, JohnHancock, Transamerica that is an ez_life_profile"
          end

          context "when the carrier is Genworth" do
            let(:carrier_name) { "Genworth" }

            it_behaves_like "AVIVA, Genworth, JohnHancock, Transamerica that is an ez_life_profile"
          end

          context "when the carrier is JohnHancock" do
            let(:carrier_name) { "JohnHancock" }

            it_behaves_like "AVIVA, Genworth, JohnHancock, Transamerica that is an ez_life_profile"
          end

          context "when the carrier is Transamerica" do
            let(:carrier_name) { "Transamerica" }

            it_behaves_like "AVIVA, Genworth, JohnHancock, Transamerica that is an ez_life_profile"
          end

          context "when the carrier is none of the above" do
            let(:carrier_name) { "SBLI" }
            let(:client_state) { "does not matter" }

            it_behaves_like "return values for control_code_determiner"

            it "uses the default parameters" do
              Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: true, esign: true, carrier: "SBLI")
              control_code_determiner.determine_control_code(crm_case, client_state)
            end
          end
        end

        context "when the crm_case does not have an ezl_join" do
          let(:ezl_join) { nil }

          context "when the client state is NY" do
            let(:client_state) { "NY" }

            context "when the crm_case is a Genworth carrier" do
              let(:carrier_name) { "Genworth" }

              context "when the crm_case is esign" do
                let(:esign) { true }

                it_behaves_like "return values for control_code_determiner"

                it "searches using the state" do
                  Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: false, esign: true, carrier: "Genworth", state: "NY")
                  control_code_determiner.determine_control_code(crm_case, client_state)
                end
              end

              context "when the crm_case is not esign" do
                let(:esign) { false }

                it_behaves_like "return values for control_code_determiner"

                it "searches using the state" do
                  Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: false, esign: false, carrier: "Genworth", state: "NY")
                  control_code_determiner.determine_control_code(crm_case, client_state)
                end
              end
            end

            context "when the crm_case is a Metlife carrier" do
              let(:carrier_name) { "Metlife" }
              let(:esign) { true }

              context "when the policy type is disability" do
                let(:policy_type_name) { "Disability" }

                it_behaves_like "return values for control_code_determiner"
                it "searches using the submitted policy type and esign false" do
                  Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: false, esign: false, carrier: "Metlife", policy_type: "Disability")
                  control_code_determiner.determine_control_code(crm_case, client_state)
                end
              end

              context "when the policy type is not disability" do
                let(:policy_type_name) { "potato" }

                it_behaves_like "return values for control_code_determiner"
                it "searches using the submitted policy type and esign false" do
                  Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: false, esign: false, carrier: "Metlife")
                  control_code_determiner.determine_control_code(crm_case, client_state)
                end
              end
            end

            context "when the crm_case is a Banner carrier" do
              let(:carrier_name) { "Banner" }

              it_behaves_like "Banner or Prudential crm_case not an ez_life_profile"
            end

            context "when the crm_case is a Prudential carrier" do
              let(:carrier_name) { "Prudential" }

              it_behaves_like "Banner or Prudential crm_case not an ez_life_profile"
            end

            context "when the crm_case is not a Genworth, Banner, or Prudential carrier" do
              let(:carrier_name) { "ING" }

              context "when the crm_case is esign" do
                let(:esign) { true }

                it_behaves_like "return values for control_code_determiner"

                it "does not search using the state" do
                  Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: false, esign: true, carrier: "ING")
                  control_code_determiner.determine_control_code(crm_case, client_state)
                end

                it "returns the control code" do
                  control_code_determiner.determine_control_code(crm_case, client_state).should == 1234
                end
              end

              context "when the crm_case is not esign" do
                let(:esign) { false }

                it_behaves_like "return values for control_code_determiner"

                it "does not search using the state" do
                  Processing::ExamOne::ControlCode.should_receive(:where).with(ez_life_profile: false, esign: false, carrier: "ING")
                  control_code_determiner.determine_control_code(crm_case, client_state)
                end
              end
            end
          end
        end
      end
    end
  end
end
