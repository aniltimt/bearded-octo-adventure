desc "Populates the ExamOne control code table, it should only need to be ran once"
task :create_control_codes => :environment do
  TaskHelpers::EzLifeControlCodeCreator.new.create_control_codes
  TaskHelpers::WholesaleControlCodeCreator.new.create_control_codes
end
