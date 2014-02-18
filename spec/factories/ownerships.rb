# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :ownership_value do |n|
    enum = ['global','user','user and descendents']
    enum[n % enum.length]
  end
end

FactoryGirl.define do
  factory :ownership do
    value {generate :ownership_value}
  end

  factory :ownership_global, :class => 'Ownership' do
    value 'global'
  end
end
