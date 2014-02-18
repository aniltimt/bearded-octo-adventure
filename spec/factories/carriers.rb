# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :carrier, class:'Carrier' do
    abbrev { Forgery::Name.company_name[0..7] }
    enabled true
    naic_code { 100000+rand(99999) }
    name { Forgery::Name.company_name }
  end
end
