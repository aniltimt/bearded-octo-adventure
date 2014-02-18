FactoryGirl.define do
  factory :crm_status_type, class:'Crm::StatusType' do
    color { "%06x" % rand("1000000".hex) }
    name { Forgery::Name.company_name }
    sort_order { rand(9) }
  end
end