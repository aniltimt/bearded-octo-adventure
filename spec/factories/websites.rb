# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :website, :class => 'Website' do
    contact_info
    url { Forgery::Internet.domain_name }
  end
end
