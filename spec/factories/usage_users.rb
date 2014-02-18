require 'active_record_base_sample.rb'

FactoryGirl.define do 
  sequence :login_sequence do |n|
    "mylogin-#{n}"
  end
end

FactoryGirl.define do
  factory :usage_user, aliases: [:agent, :parent, :owner], traits: [:person_stereotype], :class => 'Usage::User' do
    login "dummy login which shall be changed after creation"
    manager_id 1
    commission_level_id 1
    note "TextString"
    password "123456"
    password_confirmation "123456"
    parent_id {1 + rand(500)}
    agent_field_set_id nil
    role_id {1 + rand(500)}
    sales_support_field_set_id nil
    contact_info_id 1
    selected_profile_id 1

    after(:create) do |user, evaluator|
      user.update_attributes login:"my-login-#{user.id}"
    end
  end
  
  factory :usage_user_w_assoc, parent: :usage_user do
    association :agent_field_set, factory: :usage_agent_field_set
    association :agent_of_record, factory: :usage_user
    commission_level { Usage::CommissionLevel::sample }
    association :contact_info, factory: :contact_info_w_assoc
    association :manager, factory: :usage_user
    association :parent, factory: :usage_user
    role { Usage::Role::sample }
    association :sales_support_field_set, factory: :usage_sales_support_field_set
    association :staff_assignment, factory: :usage_staff_assignment_w_assoc
  end
end
