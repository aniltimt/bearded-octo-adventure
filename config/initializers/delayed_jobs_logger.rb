# Configure logger for delayed_jobs gem
Delayed::Worker.logger = Logger.new("log/delayed_jobs.log", 10, 2.megabytes)