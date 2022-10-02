class HomesController < ApplicationController
  def index
    @pagy, @records = pagy(YoutubeVideo.all)
  end
end
