# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_note, :class => 'Crm::Note' do
    case_id nil
    confidential false
    connection_id nil
    user_id nil
    note_type_id { enum_value Crm::Note }
    text "MyText"
    title "MyString"
  end
end
