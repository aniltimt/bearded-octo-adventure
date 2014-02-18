# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reporting_lead_type_assignments_for_week, :class => 'Reporting::LeadTypeAssignmentsForWeek' do
    agent_id 1
    lead_type 1
    sun 1
    mon 1
    tue 1
    wed 1
    thu 1
    fri 1
    sat 1
  end
end
