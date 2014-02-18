namespace :agency_works do
  desc "Requests updates from Agencyworks"
  task :request_updates => :environment do
    Processing::AgencyWorks.new.request_updates
  end
end
