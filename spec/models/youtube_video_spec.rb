require "rails_helper"

RSpec.describe YoutubeVideo, type: :model do
  it { should have_many(:react_histories).dependent(:destroy) }
  it { should belong_to(:user) }
end
