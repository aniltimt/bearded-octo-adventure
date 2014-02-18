# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_beneficiary, :class => 'Crm::Beneficiary' do
    contingent {[true,false].sample}
    percentage {1+rand(100)}
    birth_or_trust_date {Forgery::Date.date(:past => true, :min_delta => 0, :max_delta => (365*10)).to_s(:db) }
    genre_id {1+rand(4)}
    gender {[true,false,nil].sample}
    ssn { "%010d" % rand(9999999999) }
    name {Forgery::Name.first_name}
    trustee {Forgery::Name.first_name}
    relationship 'blah'
  end
end
