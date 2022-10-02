class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  has_many :youtube_videos, dependent: :destroy
  has_many :react_histories, dependent: :destroy

  def react(video_id, react_type)
    return if (ReactHistory.react_types.keys - ["none_react"]).exclude?(react_type)

    react = react_histories.find_or_initialize_by(youtube_video_id: video_id)
    old_react_type = react.react_type
    ActiveRecord::Base.transaction do
      updated = if react.none_react?
                  react.public_send("#{react_type}!")
                  YoutubeVideo.where(id: video_id).update_all("#{react_type}_count = #{react_type}_count + 1")
                elsif old_react_type == react_type
                  react.none_react!
                  YoutubeVideo.where(id: video_id).update_all("#{react_type}_count = #{react_type}_count - 1")
                else
                  react.public_send("#{react_type}!")
                  YoutubeVideo.where(id: video_id).update_all("#{react_type}_count = #{react_type}_count + 1, #{old_react_type}_count = #{old_react_type}_count - 1")
                end

      raise "Cann't react video. Please try again!" if updated != 1
    end

    react
  end
end
