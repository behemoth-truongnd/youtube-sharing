class HomesController < ApplicationController
  def index
    @videos = YoutubeVideo.all
  end
end
