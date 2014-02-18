desc "Send email associated with marketing task"
task :execute_marketing_tasks => :environment do
  puts "=================Executing marketing tasks==================="
    Marketing::Task.execute_auto_task_rules
  puts "==============Executing marketing tasks done=================="
end
