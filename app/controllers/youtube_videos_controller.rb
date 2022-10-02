class YoutubeVideosController < ApplicationController
  def create
    @form = ::YoutubeVideoForm.new.assign_model(YoutubeVideo.new, youtube_video_params)
    if @form.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def youtube_video_params
    params.require(:youtube_video).permit(:link)
  end
end
