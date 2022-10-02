require "rails_helper"

RSpec.describe "HomesController", type: :request do
  let!(:videos) { create_list(:youtube_video, 42) }
  let!(:user) { create(:user) }
  let!(:react_history) { create(:react_history, user_id: user.id, youtube_video_id: videos.last.id, react_type: :like) }
  let(:video_build) { YoutubeVideo.new }

  it "when not login" do
    expect(YoutubeVideo).to receive(:new).and_return(video_build)
    expect(::YoutubeVideoForm).to receive_message_chain(:new, :assign_model).with(video_build).and_return(::YoutubeVideoForm.new)
    get "/"
    expect(response).to have_http_status(200)
    expect(assigns(:videos).to_a).to eq(videos.sort_by { |video| -video.id }[0, 20])
    expect(assigns(:pagy).count).to eq(42)
    expect(assigns(:reacts)).to eq([])
  end

  context "when logined" do
    before(:each) do
      sign_in user
    end

    it "get success" do
      expect(YoutubeVideo).to receive(:new).and_return(video_build)
      expect(::YoutubeVideoForm).to receive_message_chain(:new, :assign_model).with(video_build).and_return(::YoutubeVideoForm.new)
      get "/"
      expect(response).to have_http_status(200)
      expect(assigns(:videos).length).to eq(20)
      expect(assigns(:pagy).count).to eq(42)
      expect(assigns(:reacts)).to eq([react_history])
    end
  end
end
