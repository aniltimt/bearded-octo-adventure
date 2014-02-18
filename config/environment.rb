# Load the rails application
require File.expand_path('../application', __FILE__)
# Initialize the rails application
Clu2::Application.initialize!

# Load any temporary environment files to enhance/override existing environment files
if File::exist?("tmp/#{Rails.env}.rb")
  load "tmp/#{Rails.env}.rb"
end