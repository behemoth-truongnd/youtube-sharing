class HomesController < ApplicationController
  def index
    @form = ::YoutubeVideoForm.new.assign_model(YoutubeVideo.new)
    @pagy, @videos = pagy(YoutubeVideo.all)
  end
end
