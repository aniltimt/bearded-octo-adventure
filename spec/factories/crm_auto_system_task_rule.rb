# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_auto_system_task_rule, :class => 'Crm::AutoSystemTaskRule' do
    role_id nil
    task_type_id nil
    template_id nil
    delay nil
    label Forgery::Name.company_name
    name {Forgery::Name.first_name}
    status_type_id nil
  end
end









