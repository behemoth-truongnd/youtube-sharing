class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  has_many :youtube_videos, dependent: :destroy
  has_many :react_histories, dependent: :destroy

  # rubocop:disable Rails/SkipsModelValidations
  def react(video_id, react_type)
    return if (ReactHistory.react_types.keys - ["none_react"]).exclude?(react_type)

    react = react_histories.find_or_initialize_by(youtube_video_id: video_id)
    old_react_type = react.react_type
    ActiveRecord::Base.transaction do
      if react.none_react?
        react.public_send("#{react_type}!")
        YoutubeVideo.increment_counter("#{react_type}_count".to_sym, video_id)
      elsif old_react_type == react_type
        react.none_react!
        YoutubeVideo.decrement_counter("#{react_type}_count".to_sym, video_id)
      else
        react.public_send("#{react_type}!")
        YoutubeVideo.update_counters(video_id, :"#{react_type}_count" => 1, :"#{old_react_type}_count" => -1)
      end
    end

    react
  end
  # rubocop:enable Rails/SkipsModelValidations
end
