# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_clq_template, :class => 'Marketing::ClqTemplate' do
    name "MyString"
    body "MyText"
  end
end
