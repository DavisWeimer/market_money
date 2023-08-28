FactoryBot.define do
  factory :vendor do
    name { "#{[Faker::Superhero.suffix, Faker::Science.modifier].sample} #{Faker::Restaurant.name}" }
    description { Faker::Restaurant.description }
    contact_name { "#{Faker::Emotion.adjective.capitalize} #{Faker::Name.first_name}" }
    contact_phone { Faker::PhoneNumber.cell_phone }
    credit_accepted { [true, false].sample }
  end
end
