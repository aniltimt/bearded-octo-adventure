# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_connection, class: 'Crm::Connection', traits: [:person_stereotype] do
    active true
    agent_id 1
    birth_state_id
    birth_country { Forgery::Address.country }
    citizenship_id { enum_value Crm::Citizenship }
    connection_type_id { enum_value Crm::ConnectionType }
    contact_info_id 1
    critical_note "FYI: change of address"
    dl_expiration { 1.year.from_now }
    dl_state_id
    dln "D97843"
    email_send_failed false
    gender { [true,false].sample }
    health_info_id 1
    ip_address { Forgery::Internet.ip_v4 }
    marital_status_id { enum_value MaritalStatus }
    note "This man is articulate"
    occupation { Forgery::Name.job_title }
    primary_contact_id nil
    priority_note "This man wrote Leaves of Grass"
    product_type_id { enum_value Crm::PolicyType }
    profile_id nil
    salutation { Forgery::Name.title }
    spouse_id nil
    ssn { "%010d" % rand(9999999999) }
    suffix { Forgery::Name.suffix }
    years_at_address { rand * 10 }
  end

  factory :crm_connection_w_assoc, parent: :crm_connection do
    agent
    association :contact_info, factory: :contact_info_w_assoc
    association :financial_info, factory: :crm_financial_info
    association :health_info, factory: :crm_health_info_w_assoc
    association :primary_contact, factory: :crm_connection
    association :profile, factory: :usage_profile_w_assoc
    association :spouse, factory: :crm_connection
    association :staff_assignment, factory: :usage_staff_assignment
    after(:create) do |connection, evaluator|
      FactoryGirl.create_list(:crm_activity, 2, crm_connection: connection)
      FactoryGirl.create_list(:crm_case, 2, crm_connection: connection)
      FactoryGirl.create_list(:crm_note, 2, crm_connection: connection)
      FactoryGirl.create_list(:crm_physician, 2, crm_connection: connection)
      FactoryGirl.create_list(:tagging_tag_w_key, 2, crm_connection: connection)
    end
  end

  factory :crm_connection_w_contact_info, parent: :crm_connection do
    association :contact_info, factory: :contact_info_w_assoc
  end
end
