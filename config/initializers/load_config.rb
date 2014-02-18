# This file loads the data from <Rails.root>/config/config.yml
APP_CONFIG = (
  environments = YAML::load_file("#{Rails.root}/config/config.yml")
  environments['all'].merge environments[Rails.env]
  )

# Add term life insurance face amounts to app config
APP_CONFIG['face_amounts'] = (
    amounts = Array.new
    25000.step(100000,25000){|x|amounts<<x}
    150000.step(1000000,50000){|x|amounts<<x}
    1100000.step(2000000,100000){|x|amounts<<x}
    2250000.step(5000000,250000){|x|amounts<<x}
    amounts
    )

APP_CONFIG['cholesterol'] = (100..299).to_a
APP_CONFIG['cholesterol_hdl'] = (25..99).map{|x| "%.02f" % (x/10.0)}
APP_CONFIG['bp_systolic'] = (119..249).to_a
APP_CONFIG['bp_diastolic'] = (79..179).to_a

# ENCRYPTION_KEY should be defined in an environment file
if defined? ENCRYPTION_KEY
  APP_CONFIG[:encryption_key] = ENCRYPTION_KEY
end