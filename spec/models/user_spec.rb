require "rails_helper"

RSpec.describe User, type: :model do
  it { should have_many(:youtube_videos).dependent(:destroy) }
  it { should have_many(:react_histories).dependent(:destroy) }

  context ".react" do
    let(:user) { create(:user) }
    let!(:youtube_videos) { create_list(:youtube_video, 20) }

    context "when run like action" do
      it "when haven't react history" do
        expect(ReactHistory.count).to eq(0)
        user.react(youtube_videos.first.id, "like")
        expect(ReactHistory.count).to eq(1)
        expect(ReactHistory.first.react_type).to eq("like")
        expect(ReactHistory.first.user_id).to eq(user.id)
        expect(ReactHistory.first.youtube_video_id).to eq(youtube_videos.first.id)
        expect(youtube_videos.first.reload.like_count).to eq(1)
        expect(youtube_videos.first.reload.dislike_count).to eq(0)
      end

      it "when have react history and react_type eq like" do
        user.react(youtube_videos.first.id, "like")
        expect(youtube_videos.first.reload.like_count).to eq(1)
        expect(youtube_videos.first.reload.dislike_count).to eq(0)
        user.react(youtube_videos.first.id, "like")
        expect(ReactHistory.count).to eq(1)
        expect(ReactHistory.first.react_type).to eq("none_react")
        expect(ReactHistory.first.user_id).to eq(user.id)
        expect(ReactHistory.first.youtube_video_id).to eq(youtube_videos.first.id)
        expect(youtube_videos.first.reload.like_count).to eq(0)
        expect(youtube_videos.first.reload.dislike_count).to eq(0)
      end

      it "when have react history and react_type eq dislike" do
        user.react(youtube_videos.first.id, "dislike")
        expect(youtube_videos.first.reload.like_count).to eq(0)
        expect(youtube_videos.first.reload.dislike_count).to eq(1)
        user.react(youtube_videos.first.id, "like")
        expect(ReactHistory.count).to eq(1)
        expect(ReactHistory.first.react_type).to eq("like")
        expect(ReactHistory.first.user_id).to eq(user.id)
        expect(ReactHistory.first.youtube_video_id).to eq(youtube_videos.first.id)
        expect(youtube_videos.first.reload.like_count).to eq(1)
        expect(youtube_videos.first.reload.dislike_count).to eq(0)
      end

      it "when have react history and react_type eq none_react" do
        user.react_histories.create(react_type: :none_react, youtube_video_id: youtube_videos.first.id)
        expect(youtube_videos.first.reload.like_count).to eq(0)
        expect(youtube_videos.first.reload.dislike_count).to eq(0)
        user.react(youtube_videos.first.id, "like")
        expect(ReactHistory.count).to eq(1)
        expect(ReactHistory.first.react_type).to eq("like")
        expect(ReactHistory.first.user_id).to eq(user.id)
        expect(ReactHistory.first.youtube_video_id).to eq(youtube_videos.first.id)
        expect(youtube_videos.first.reload.like_count).to eq(1)
        expect(youtube_videos.first.reload.dislike_count).to eq(0)
      end
    end

    context "when run dislike action" do
      it "when haven't react history" do
        expect(ReactHistory.count).to eq(0)
        user.react(youtube_videos.first.id, "dislike")
        expect(ReactHistory.count).to eq(1)
        expect(ReactHistory.first.react_type).to eq("dislike")
        expect(ReactHistory.first.user_id).to eq(user.id)
        expect(ReactHistory.first.youtube_video_id).to eq(youtube_videos.first.id)
        expect(youtube_videos.first.reload.like_count).to eq(0)
        expect(youtube_videos.first.reload.dislike_count).to eq(1)
      end

      it "when have react history and react_type eq like" do
        user.react(youtube_videos.first.id, "like")
        expect(youtube_videos.first.reload.like_count).to eq(1)
        expect(youtube_videos.first.reload.dislike_count).to eq(0)
        user.react(youtube_videos.first.id, "dislike")
        expect(ReactHistory.count).to eq(1)
        expect(ReactHistory.first.react_type).to eq("dislike")
        expect(ReactHistory.first.user_id).to eq(user.id)
        expect(ReactHistory.first.youtube_video_id).to eq(youtube_videos.first.id)
        expect(youtube_videos.first.reload.like_count).to eq(0)
        expect(youtube_videos.first.reload.dislike_count).to eq(1)
      end

      it "when have react history and react_type eq dislike" do
        user.react(youtube_videos.first.id, "dislike")
        expect(youtube_videos.first.reload.like_count).to eq(0)
        expect(youtube_videos.first.reload.dislike_count).to eq(1)
        user.react(youtube_videos.first.id, "dislike")
        expect(ReactHistory.count).to eq(1)
        expect(ReactHistory.first.react_type).to eq("none_react")
        expect(ReactHistory.first.user_id).to eq(user.id)
        expect(ReactHistory.first.youtube_video_id).to eq(youtube_videos.first.id)
        expect(youtube_videos.first.reload.like_count).to eq(0)
        expect(youtube_videos.first.reload.dislike_count).to eq(0)
      end

      it "when have react history and react_type eq none_react" do
        user.react_histories.create(react_type: :none_react, youtube_video_id: youtube_videos.first.id)
        expect(youtube_videos.first.reload.like_count).to eq(0)
        expect(youtube_videos.first.reload.dislike_count).to eq(0)
        user.react(youtube_videos.first.id, "dislike")
        expect(ReactHistory.count).to eq(1)
        expect(ReactHistory.first.react_type).to eq("dislike")
        expect(ReactHistory.first.user_id).to eq(user.id)
        expect(ReactHistory.first.youtube_video_id).to eq(youtube_videos.first.id)
        expect(youtube_videos.first.reload.like_count).to eq(0)
        expect(youtube_videos.first.reload.dislike_count).to eq(1)
      end
    end
  end
end
