FactoryGirl.define do
  trait :person_stereotype do
    anniversary { Forgery::Date.date(:past => true, :min_delta => 1, :max_delta => 60*365).to_s(:db) }
    birth { Forgery::Date.date(:past => true, :min_delta => 20*365, :max_delta => 70*365).to_s(:db) }
    first_name { Forgery::Name.first_name }
    gender [true,false].sample
    last_name { Forgery::Name.last_name }
    middle_name { Forgery::Name.first_name }
    nickname { Forgery::Name.first_name }
    title { Forgery::Name.title }
  end
end