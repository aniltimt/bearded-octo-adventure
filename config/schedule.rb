# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 15.minutes do
  rake "send_system_task_email_agents"
end

every 15.minutes do
  rake "send_system_task_emails"
end

every :day, :at => '12:00am' do
  rake "execute_marketing_tasks"
end

every :day, :at => '12:00pm' do
  rake "execute_marketing_tasks"
end

every '55 5,8,11,12,13,14,15,16,17,19,21,22,23 * * *' do
  rake "agency_works:request_updates"
end

every 15.minutes do
  rake "exam_one:get_statuses"
end
