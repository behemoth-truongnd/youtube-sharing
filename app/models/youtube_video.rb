class YoutubeVideo < ApplicationRecord
  has_many :react_histories, dependent: :destroy
  belongs_to :user
end
