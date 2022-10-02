FactoryBot.define do
  factory :youtube_video do
    association :user
    title { Faker::Movie.title }
    description { Faker::Movie.quote }
    youtube_id { "fmyvWz5TUWg" }
  end
end
