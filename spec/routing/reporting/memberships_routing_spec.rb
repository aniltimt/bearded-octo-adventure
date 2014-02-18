require "spec_helper"

describe Reporting::MembershipsController do
  describe "routing" do

    it "routes to #index" do
      get("/reporting/memberships").should route_to("reporting/memberships#index")
    end

    it "routes to #new" do
      get("/reporting/memberships/new").should route_to("reporting/memberships#new")
    end

    it "routes to #show" do
      get("/reporting/memberships/1").should route_to("reporting/memberships#show", :id => "1")
    end

    it "routes to #edit" do
      get("/reporting/memberships/1/edit").should route_to("reporting/memberships#edit", :id => "1")
    end

    it "routes to #create" do
      post("/reporting/memberships").should route_to("reporting/memberships#create")
    end

    it "routes to #update" do
      put("/reporting/memberships/1").should route_to("reporting/memberships#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/reporting/memberships/1").should route_to("reporting/memberships#destroy", :id => "1")
    end

  end
end
