require 'active_record_base_sample.rb'

FactoryGirl.define do
  factory :usage_profile, :class => 'Usage::Profile' do
    #owner_id nil
    # ownership { Ownership::sample }
    # logo_file 'my-logo.png'
    name { Forgery::Name.company_name }
    #contact_info_id nil
  end

  factory :usage_profile_w_assoc, parent: :usage_profile do
    association :contact_info, factory: :contact_info_w_assoc
  end
end
