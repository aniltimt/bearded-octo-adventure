require "spec_helper"

describe Reporting::MembershipsController do
  let(:valid_attributes) { {} }
  let(:valid_session) { {} }

  describe "#index" do
    let(:memberships) { [fire_double("Reporting::Membership")] }

    before do
      Reporting::Membership.stub(:all).and_return(memberships)
    end

    it "assigns all reporting_memberships as @reporting_memberships" do
      get :index, {}, valid_session
      assigns[:reporting_memberships].should == memberships
    end
  end

  describe "#show" do
    let(:membership) { fire_double("Reporting::Membership", id: 42) }

    before do
      Reporting::Membership.stub(:find).with("42").and_return(membership)
    end

    it "assigns the requested reporting_membership as @reporting_membership" do
      get :show, {:id => 42}, valid_session
      assigns[:reporting_membership].should == membership
    end
  end

  describe "#new" do
    it "assigns a new reporting_membership as @reporting_membership" do
      get :new, {}, valid_session
      assigns(:reporting_membership).should be_a_new(Reporting::Membership)
    end
  end

  describe "#edit" do
    let(:membership) { fire_double("Reporting::Membership", id: 42) }

    before do
      Reporting::Membership.stub(:find).with("42").and_return(membership)
    end

    it "assigns the requested reporting_membership as @reporting_membership" do
      get :edit, {:id => 42}, valid_session
      assigns(:reporting_membership).should == membership
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "creates a new Reporting::Membership" do
        expect {
          post :create, {:reporting_membership => valid_attributes}, valid_session
        }.to change(Reporting::Membership, :count).by(1)
      end

      it "assigns a newly created reporting_membership as @reporting_membership" do
        post :create, {:reporting_membership => valid_attributes}, valid_session
        assigns(:reporting_membership).should be_a(Reporting::Membership)
        assigns(:reporting_membership).should be_persisted
      end

      it "redirects to the created reporting_membership" do
        pending "Broken"
        post :create, {:reporting_membership => valid_attributes}, valid_session
        response.should redirect_to(Reporting::Membership.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved reporting_membership as @reporting_membership" do
        # Trigger the behavior that occurs when invalid params are submitted
        Reporting::Membership.any_instance.stub(:save).and_return(false)
        post :create, {:reporting_membership => {  }}, valid_session
        assigns(:reporting_membership).should be_a_new(Reporting::Membership)
      end

      it "re-renders the 'new' template" do
        pending "Broken"
        # Trigger the behavior that occurs when invalid params are submitted
        Reporting::Membership.any_instance.stub(:save).and_return(false)
        post :create, {:reporting_membership => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "#update" do
    describe "with valid params" do
      it "updates the requested reporting_membership" do
        membership = Reporting::Membership.create! valid_attributes
        # Assuming there are no other reporting_memberships in the database, this
        # specifies that the Reporting::Membership created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Reporting::Membership.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => membership.to_param, :reporting_membership => { "these" => "params" }}, valid_session
      end

      it "assigns the requested reporting_membership as @reporting_membership" do
        membership = Reporting::Membership.create! valid_attributes
        put :update, {:id => membership.to_param, :reporting_membership => valid_attributes}, valid_session
        assigns(:reporting_membership).should eq(membership)
      end

      it "redirects to the reporting_membership" do
        pending "Broken"
        membership = Reporting::Membership.create! valid_attributes
        put :update, {:id => membership.to_param, :reporting_membership => valid_attributes}, valid_session
        response.should redirect_to(membership)
      end
    end

    describe "with invalid params" do
      it "assigns the reporting_membership as @reporting_membership" do
        membership = Reporting::Membership.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Reporting::Membership.any_instance.stub(:save).and_return(false)
        put :update, {:id => membership.to_param, :reporting_membership => {  }}, valid_session
        assigns(:reporting_membership).should eq(membership)
      end

      it "re-renders the 'edit' template" do
        pending "Broken"
        membership = Reporting::Membership.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Reporting::Membership.any_instance.stub(:save).and_return(false)
        put :update, {:id => membership.to_param, :reporting_membership => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested reporting_membership" do
      membership = Reporting::Membership.create! valid_attributes
      expect {
        delete :destroy, {:id => membership.to_param}, valid_session
      }.to change(Reporting::Membership, :count).by(-1)
    end

    it "redirects to the reporting_memberships list" do
      pending "Broken"
      membership = Reporting::Membership.create! valid_attributes
      delete :destroy, {:id => membership.to_param}, valid_session
      response.should redirect_to(reporting_memberships_url)
    end
  end
end
