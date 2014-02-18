# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_sales_support_field_set, :class => 'Usage::SalesSupportFieldSet' do
    docusign_email "MyString"
    docusign_account_id "MyString"
    docusign_password "MyString"
    metlife_agent_id "MyString"
  end
end
