require "spec_helper"
require "rake"
load "#{Rails.root}/Rakefile"

describe "agency_works:request_updates" do
  let(:agency_works) { fire_double("Processing::AgencyWorks") }

  before do
    Processing::AgencyWorks.stub(:new).and_return(agency_works)
    agency_works.stub(:request_updates)
  end

  it "requests updates" do
    agency_works.should_receive(:request_updates)
    Rake::Task["agency_works:request_updates"].invoke
  end
end
