class HomesController < ApplicationController
  def index
    @form = ::YoutubeVideoForm.new.assign_model(YoutubeVideo.new)
    @pagy, @videos = pagy(YoutubeVideo.all)
    @reacts = if current_user.present?
                current_user.react_histories.where(youtube_video_id: @videos.map(&:id))
              else
                []
              end
  end
end
