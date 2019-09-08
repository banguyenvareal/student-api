FactoryBot.define do
  factory :student do
    name { "MyString" }
    user_id { rand(1..10) }
  end
end
