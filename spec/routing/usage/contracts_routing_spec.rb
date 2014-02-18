require "spec_helper"

describe Usage::ContractsController do
  describe "routing" do

    it "routes to #index" do
      get("/usage/contracts").should route_to("usage/contracts#index")
    end

    it "routes to #new" do
      get("/usage/contracts/new").should route_to("usage/contracts#new")
    end

    it "routes to #show" do
      get("/usage/contracts/1").should route_to("usage/contracts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/usage/contracts/1/edit").should route_to("usage/contracts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/usage/contracts").should route_to("usage/contracts#create")
    end

    it "routes to #update" do
      put("/usage/contracts/1").should route_to("usage/contracts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/usage/contracts/1").should route_to("usage/contracts#destroy", :id => "1")
    end

  end
end
