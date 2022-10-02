class YoutubeVideo < ApplicationRecord
  belongs_to :user

  validates :youtube_id, :title, presence: true
  validates :youtube_id, length: { maximum: 255 }

  validate :validate_youtube_id

  private

  def validate_youtube_id
    return if youtube_id.blank?

    yt = Yt::Video.new(id: youtube_id)
    yt.title
  rescue
    errors.add(:youtube_id, :invalid)
  end
end
