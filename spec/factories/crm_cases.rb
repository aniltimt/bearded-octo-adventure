FactoryGirl.define do
  factory :crm_case, class: 'Crm::Case', traits: [:belongs_to_connection] do
    active true
    agent_id nil
    approved_details_id nil
    approved_premium_due { rand * rand(100) }
    bind false
    cross_sell false
    current_insurance_amount "amt"
    effective_date nil
    equal_share_contingent_bens nil
    equal_share_primary_bens nil
    exam_company { "foooo" }
    exam_num "3rjkl234"
    exam_status "not done"
    exam_time nil
    insurance_exists false
    ipo false
    owner_id nil
    policy_number "342k423"
    policy_period_expiration nil
    quoted_details_id nil
    staff_assignment_id nil
    status_id nil
    submitted_details nil
    submitted_qualified 0
    termination_date nil
    underwriter_assist false
    up_sell 0
  end

  factory :crm_case_w_assoc, parent: :crm_case do
    association :quoted_details, factory: :quoting_result
    association :submitted_details, factory: :quoting_result
    association :approved_details, factory: :quoting_result
  end
end
