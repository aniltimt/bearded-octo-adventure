# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_staff_assignment, :class => 'Usage::StaffAssignment' do
    administrative_assistant_id nil
    case_manager_id nil
    manager_id nil
    policy_specialist_id nil
    sales_assistant_id nil
    sales_coordinator_id nil
    sales_support_id nil
  end

  factory :usage_staff_assignment_w_assoc, parent: :usage_staff_assignment do
    association :administrative_assistant, factory: :usage_user, role:Usage::Role.find_by_name('administrative assistant')
    association :case_manager, factory: :usage_user, role:Usage::Role.find_by_name('case manager')
    association :manager, factory: :usage_user, role:Usage::Role.find_by_name('manager')
    association :policy_specialist, factory: :usage_user, role:Usage::Role.find_by_name('policy specialist')
    association :sales_assistant, factory: :usage_user, role:Usage::Role.find_by_name('sales assistant')
    association :sales_coordinator, factory: :usage_user, role:Usage::Role.find_by_name('sales coordinator')
    association :sales_support, factory: :usage_user, role:Usage::Role.find_by_name('sales support')
  end
end
