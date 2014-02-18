desc "Send email for System task with type email agent"
task :send_system_task_email_agents => :environment do
  Usage::User.all.each do |user|
    puts "=================Sending system task emails of #{user.first_name}==================="
    user.system_task_email_agent
    puts "=================Sending system task emails done of #{user.first_name}==================="
  end
end
