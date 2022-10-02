require "rails_helper"

RSpec.describe ReactHistory, type: :model do
  it { should define_enum_for(:react_type).with_values([:none_react, :like, :dislike]) }
end
