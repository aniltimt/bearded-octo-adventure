# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quoting_tli_health_class_option, :class => 'Quoting::TliHealthClassOption' do
    name "MyString"
    value "MyString"
  end
end
