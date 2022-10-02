require "rails_helper"

RSpec.describe "YoutubeVideosController", type: :request do
  let!(:videos) { create_list(:youtube_video, 42) }
  let!(:user) { create(:user) }
  let!(:react_history) { create(:react_history, user_id: user.id, youtube_video_id: videos.first.id, react_type: :like) }
  let(:video_build) { YoutubeVideo.new }

  context ".create" do
    it "when not login" do
      headers = { "ACCEPT" => "application/json" }
      post "/youtube_videos", params: { youtube_video_form: { youtube_url: "https://www.youtube.com/watch?v=yZDTBItc3ZM" } }
      expect(response).to have_http_status(302)
    end

    context "when login" do
      before(:each) do
        sign_in user
      end

      it "when form save success" do
        success = double("Success", save: true)
        expect(::YoutubeVideoForm).to receive_message_chain(:new, :assign_model).and_return(success)
        headers = { "ACCEPT" => "application/json" }
        post "/youtube_videos", params: { youtube_video_form: { youtube_url: "https://www.youtube.com/watch?v=yZDTBItc3ZM" } }
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)["success"]).to eq(true)
      end

      it "when form save false" do
        expect(::YoutubeVideoForm).to receive_message_chain(:new, :assign_model).and_return(::YoutubeVideoForm.new)
        headers = { "ACCEPT" => "application/json" }
        post "/youtube_videos", params: { youtube_video_form: { youtube_url: "https://www.youtube.com/watch?v=yZDTBItc3ZM" } }
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)["success"]).to eq(false)
      end
    end
  end

  context ".react" do
    it "when not login" do
      headers = { "ACCEPT" => "application/json" }
      post "/youtube_videos/#{videos.first.id}/react", params: { react_type: "like" }
      expect(response).to have_http_status(302)
    end

    context "when login" do
      before(:each) do
        sign_in user
      end

      it "when form save success" do
        headers = { "ACCEPT" => "application/json" }
        post "/youtube_videos/#{videos.first.id}/react", params: { react_type: "like" }
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end
end
