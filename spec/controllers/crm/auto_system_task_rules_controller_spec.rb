require "spec_helper"

describe Crm::AutoSystemTaskRulesController do
  describe "#create" do
    let(:current_user) { fire_double("Usage::User") }
    let(:crm_auto_system_task_rule) { fire_double("Crm::AutoSystemTaskRule") }
    let(:params) { {crm_auto_system_task_rule: {}} }

    before do
      controller.stub(:current_user).and_return(current_user)
      Crm::AutoSystemTaskRule.stub(:new).with(params[:crm_auto_system_task_rule]).and_return(crm_auto_system_task_rule)
    end

    context "when save is successful" do
      let(:status_type) { fire_double("Crm::StatusType", id: 42) }
      let(:auto_system_task_rules) { [fire_double("Crm::AutoSystemTaskRule")] }

      before do
        crm_auto_system_task_rule.stub(:save).and_return(true)
        crm_auto_system_task_rule.stub(:status_type).and_return(status_type)
        status_type.stub(:auto_system_task_rules).and_return(auto_system_task_rules)
      end

      it "assigns auto_system_task_rules" do
        get "create", params
        assigns[:auto_system_task_rules].should == auto_system_task_rules
      end

      it "renders the index action" do
        get "create", params
        response.should render_template("index")
      end
    end
  end
end
