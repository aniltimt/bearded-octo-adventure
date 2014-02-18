require "spec_helper"
require "debugger"

describe Crm::StatusTypesController do
  let(:current_user) { fire_double("Usage::User", id: 2) }

  before do
    controller.stub(:current_user).and_return(current_user)
  end

  describe "#index" do
    let(:first_status_type) { stub(sort_order: 1) }
    let(:second_status_type) { stub(sort_order: 2) }
    let(:unsorted_status_types) { [second_status_type, first_status_type] }

    before do
      Crm::StatusType.stub(:all).with(current_user).and_return(unsorted_status_types)
    end

    it "assigns status_types" do
      xhr :get, "index"
      assigns[:status_types].should == [first_status_type, second_status_type]
    end

    it "returns http success" do
      xhr :get, "index"
      response.should be_success
    end
  end

  describe "#new" do
    it "returns http success" do
      xhr :get, "new"
      response.should be_success
    end
  end

  describe "#create" do
    let(:status_type) { stub(sort_order: 1) }
    let(:params) { {crm_status_type: {name: "test_type"}} }

    before do
      Crm::StatusType.stub(:all).with(current_user).and_return([status_type])
      Crm::StatusType.stub(:create)
    end

    it "creates a new status type" do
      Crm::StatusType.should_receive(:create).with("name" => "test_type", "owner_id" => 2)
      xhr :post, "create", params
    end

    it "assigns status_types" do
      xhr :post, "create", params
      assigns[:status_types].should == [status_type]
    end

    it "returns http success" do
      xhr :post, "create", params
      response.should be_success
    end
  end

  describe "#edit" do
    let(:status_type) { fire_double("Crm::StatusType") }
    let(:ownerships) { [stub] }
    let(:params) { {id: 42} }

    before do
      Crm::StatusType.stub(:find).with("42").and_return(status_type)
      Ownership.stub(:all).and_return(ownerships)
    end

    it "assigns status_type" do
      xhr :get, "edit", params
      assigns[:status_type].should == status_type
    end

    it "assigns ownershipts" do
      xhr :get, "edit", params
      assigns[:ownerships].should == ownerships
    end

    it "returns http success" do
      xhr :get, "edit", params
      response.should be_success
    end
  end

  describe "#update" do
    let(:status_type) { stub(sort_order: 1) }
    let(:params) { {id: 42, crm_status_type: "test_type"} }

    before do
      Crm::StatusType.stub(:find).with("42").and_return(status_type)
    end

    context "when updating attributes is successful" do
      before do
        Crm::StatusType.stub(:all).with(current_user).and_return([status_type])
        status_type.stub(:update_attributes).with("test_type").and_return(true)
      end

      it "assigns status_types" do
        xhr :put, "update", params
        assigns[:status_types].should == [status_type]
      end

      it "returns http success" do
        xhr :put, "update", params
        response.should be_success
      end
    end
  end
end
