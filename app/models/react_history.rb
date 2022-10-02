class ReactHistory < ApplicationRecord
  scope :by_video_id, ->(id) {
    where(youtube_video_id: id)
  }

  enum react_type: {
    none_react: 0,
    like: 1,
    dislike: 2,
  }
end
