# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quoting_spia_extra_field_set, :class => 'Quoting::SpiaExtraFieldSet' do
    income_option "MyString"
  end
end
