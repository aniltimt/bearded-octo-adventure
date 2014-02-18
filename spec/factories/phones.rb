# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone, :class => 'Phone' do
    contact_info
    ext { "%03d" % rand(9999999999) }
    phone_type_id 1
    value { "%010d" % rand(9999999999) }
  end
end
