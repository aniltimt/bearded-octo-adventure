namespace :exam_one do
  desc "Requests status updates from ExamOne"
  task :get_statuses => :environment do
    Processing::ExamOne.new.get_statuses
  end
end
