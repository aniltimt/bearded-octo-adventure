# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quoting_quote_param_dynamic_set, :class => 'Quoting::QuoteParamDynamicSet' do
    category_id 1
    connection_id 1
    face_amount 1
    premium_mode_id 1
  end
end
