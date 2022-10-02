class YoutubeVideoForm < BaseForm
  attr_accessor :video

  YT_LINK_FORMAT = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i

  attribute :youtube_url, :string

  validates :youtube_url, presence: true
  validates :youtube_url, format: YT_LINK_FORMAT, allow_blank: true
  validate :validate_youtube_id

  def save
    return unless super

    model.assign_attributes(
      youtube_id: video.id,
      title: video.title,
      description: video.description,
      thumbnail_url: video.thumbnail_url,
      duration: video.duration,
      published_at: video.published_at,
    )
    model.save
  end

  private

  def validate_youtube_id
    return if errors.present?

    youtube_id = YT_LINK_FORMAT.match(youtube_url)[2]
    self.video = Yt::Video.new(id: youtube_id)
    raise StandardError.new("Title is blank!") if self.video.title.blank?

    if YoutubeVideo.where.not(id: model.id).exists?(youtube_id: youtube_id)
      errors.add(:youtube_url, :taken)
    end
  rescue => _e
    errors.add(:youtube_url, :invalid)
  end
end
