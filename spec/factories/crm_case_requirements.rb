# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_case_requirement, :class => 'Crm::CaseRequirement' do
    name "MyString"
    required_of "MyString"
    ordered "2013-01-21"
    recieved "2013-01-21"
    requirement_type "MyString"
    status "MyString"
  end
end
