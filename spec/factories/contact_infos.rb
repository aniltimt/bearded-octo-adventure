# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact_info, class: ContactInfo do
    company { Forgery::Name.company_name }
    preferred_contact_method_id { enum_value Crm::ContactMethod }
    fax { Forgery::Address.phone }
    city { Forgery::Address.city }
    state_id
    zip { Forgery::Address.zip }
  end

  factory :contact_info_w_assoc, parent: :contact_info do
    state { State.sample }
    after(:create) do |contact_info, evaluator|
      FactoryGirl.create_list(:address, 2, contact_info: contact_info)
      FactoryGirl.create_list(:email_address, 2, contact_info: contact_info)
      FactoryGirl.create_list(:phone, 2, contact_info: contact_info)
    end
  end

end
