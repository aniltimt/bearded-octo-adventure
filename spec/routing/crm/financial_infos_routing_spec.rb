require "spec_helper"

describe Crm::FinancialInfosController do
  describe "routing" do

    it "routes to #index" do
      get("/crm/financial_infos").should route_to("crm/financial_infos#index")
    end

    it "routes to #new" do
      get("/crm/financial_infos/new").should route_to("crm/financial_infos#new")
    end

    it "routes to #show" do
      get("/crm/financial_infos/1").should route_to("crm/financial_infos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/crm/financial_infos/1/edit").should route_to("crm/financial_infos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/crm/financial_infos").should route_to("crm/financial_infos#create")
    end

    it "routes to #update" do
      put("/crm/financial_infos/1").should route_to("crm/financial_infos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/crm/financial_infos/1").should route_to("crm/financial_infos#destroy", :id => "1")
    end

  end
end
