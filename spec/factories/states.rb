# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :state, aliases: [:birth_state, :dl_state], class: 'State' do
    abbrev { Forgery::Address.state_abbrev }
    compulife_code 1
    name { Forgery::Address.state }
    tz_id 1
  end

  sequence :state_id, aliases: [:birth_state_id, :dl_state_id] do
    1+ rand( @states_count ||= State.count )
  end
end
