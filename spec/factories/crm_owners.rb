# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_owner, :class => 'Crm::Owner' do
    case_id nil
    contact_info_id nil
    tin "4123423143"
    name {Forgery::Name.company_name}
    relationship "foo"
    ssn "1423423423"
    gender {[true,false,nil].sample}
    genre_id {(1..3).to_a.sample}
    birth_or_trust_date { Forgery::Date.date past:true, min_delta:1, max_delta:(365*60) }
  end
end
