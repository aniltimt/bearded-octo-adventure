# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_email_smtp_server, :class => 'Marketing::Email::SmtpServer' do
    owner_id 1
    ownership_id 1
    host "MyString"
    password "MyString"
    port 1
    ssl false
    username "MyString"
  end
end
