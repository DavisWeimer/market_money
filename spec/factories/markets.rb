FactoryBot.define do
  factory :market do
    name { "#{Faker::TvShows::Simpsons.character.titleize} #{Faker::Company.industry.titleize}" }
    street { Faker::Address.street_name }
    city { Faker::Fantasy::Tolkien.location }
    county { Faker::Address.community }
    state { Faker::Books::Lovecraft.location }
    zip { Faker::Address.zip_code.slice(0, 5) }
    lat { Faker::Address.latitude.round(4) }
    lon { Faker::Address.longitude.round(4) }
  end
end
