# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_vici_client_data, :class => 'Marketing::Vici::ClientData' do
    client_id 1
    vici_id 1
  end
end
