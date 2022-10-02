FactoryBot.define do
  factory :react_history do
    association :user
    association :youtube_video
    react_type { [:none_react, :like, :dislike].sample }
  end
end
