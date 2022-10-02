require "rails_helper"

RSpec.describe YoutubeVideoForm do
  let(:user) { create(:user) }
  let(:video) { create(:youtube_video, user: user) }

  context "when false validate" do
    it "when youtube_url blank" do
      form = YoutubeVideoForm.new.assign_model(video, { youtube_url: "" })
      expect(form.valid?).to eq(false)
    end

    it "when youtube_url present but invalid format" do
      form = YoutubeVideoForm.new.assign_model(video, { youtube_url: "https://google.com" })
      expect(form.valid?).to eq(false)
    end

    it "when youtube_url present valid format but youtube_id invalid" do
      form = YoutubeVideoForm.new.assign_model(video, { youtube_url: "https://www.youtube.com/watch?v=aa" })
      expect(form.valid?).to eq(false)
    end

    it "when youtube_url present valid format, id valid but taken" do
      create(:youtube_video, user: user, youtube_id: "yZDTBItc3ZM")
      form = YoutubeVideoForm.new.assign_model(video, { youtube_url: "https://www.youtube.com/watch?v=yZDTBItc3ZM" })
      expect(form.valid?).to eq(false)
    end
  end

  context "when success" do
    it do
      form = YoutubeVideoForm.new.assign_model(user.youtube_videos.build, { youtube_url: "https://www.youtube.com/watch?v=yZDTBItc3ZM" })
      expect(form.valid?).to eq(true)
      expect(form.save).to eq(true)
      expect(YoutubeVideo.last.youtube_id).to eq("yZDTBItc3ZM")
    end
  end
end
