FactoryGirl.define do
  factory :crm_system_task, class:'Crm::SystemTask' do
    completed_at { Forgery::Date.date(:past => true, :min_delta => 0, :max_delta => 600).to_s(:db) }
    template_id { 1+rand(100) }
    label { Forgery::Name.company_name }
    owner_id { 1+rand(100) }
  end
end
