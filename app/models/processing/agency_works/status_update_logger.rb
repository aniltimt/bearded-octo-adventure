module Processing
  class AgencyWorks
    class StatusUpdateLogger
      def log_status_updates(record_count, update_stats, execution_time)
        File.open(File.join(AGENCY_WORKS_LOG_DIRECTORY, Time.now.strftime("%Y-%m-%d") + ".log"), "a") do |file|
          file.puts "-" * 100
          file.puts "Number of XML Records: #{record_count}"
          file.puts "Number of Status Failures: #{update_stats[:status_failures]}"
          file.puts "Number of Status Changes Attempted: #{update_stats[:status_changes]}"
          file.puts "Number of Policies Matched: #{update_stats[:policies_matched]}"
          file.puts "Number of Policies ready for change: #{update_stats[:total_cases_ready]}"
          file.puts "Number of Successful Changes: #{update_stats[:successful_changes]}"
          file.puts "Number of EZLife changes: #{update_stats[:ez_life_changes]}"
          file.puts "Execution time in minutes: #{execution_time/60}"
          file.puts "Execution time in seconds: #{execution_time}"
          file.puts "-" * 100
        end
      end
    end
  end
end
