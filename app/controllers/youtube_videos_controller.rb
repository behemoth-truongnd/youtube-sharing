class YoutubeVideosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def create
    @form = ::YoutubeVideoForm.new.assign_model(current_user.youtube_videos.build, youtube_video_params)
    if @form.save
      render json: { success: true, message: "Share video success" }
    else
      render json: { success: false, messages: @form.errors.to_hash(true) }
    end
  end

  def react
    video = YoutubeVideo.find(params[:id])
    react = current_user.react(video.id, params[:react_type])
    video.reload

    render json: { like_count: video.like_count, dislike_count: video.dislike_count, react_type: react.react_type }
  end

  private

  def youtube_video_params
    params.require(:youtube_video_form).permit(:youtube_url)
  end
end
