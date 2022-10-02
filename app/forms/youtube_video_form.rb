class YoutubeVideoForm < BaseForm
  YT_LINK_FORMAT = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i

  attribute :link, :string

  validates :link, presence: true, format: YT_LINK_FORMAT

  def save
    return unless super
  end
end
