# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reporting_lead_type_assignment_total, :class => 'Reporting::LeadTypeAssignmentTotal' do
    count 1
    lead_type 1
    start "2013-02-13"
  end
end
