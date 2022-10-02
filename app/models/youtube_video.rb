class YoutubeVideo < ApplicationRecord
  belongs_to :user

  def yt
    @yt ||= Yt::Video.new(id: youtube_id)
  end
end
