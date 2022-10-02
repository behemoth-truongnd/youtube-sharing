class YoutubeVideo < ApplicationRecord
  has_many :react_histories, dependent: :destroy
  belongs_to :user

  def yt
    @yt ||= Yt::Video.new(id: youtube_id)
  end

  # def react(user, react_type)
  #   return if ReactHistory.react_types.keys.exclude?(react_type)

  #   user.
  #   case react_type

  # end

  # def update_counter!
  #   updated = ::YoutubeVideo.where(id: id).update_all("dislike_count = #{ReactHistory.where(youtube_video_id: id).dislike.count}, like_count = #{ReactHistory.where(youtube_video_id: id).dislike.count}")
  #   raise "Cann't update video counter! #{id}" if updated != 1
  # end
end
