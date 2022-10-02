class YoutubeVideosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def create
    @form = ::YoutubeVideoForm.new.assign_model(current_user.youtube_videos.build, youtube_video_params)
    if @form.save
      render json: { sucess: true, message: "Share video success" }
    else
      render json: { sucess: false, messages: @form.errors.to_hash(true) }
    end
  end

  private

  def youtube_video_params
    params.require(:youtube_video_form).permit(:youtube_url)
  end

  def set_current_user
    Current.user = current_user
  end
end
