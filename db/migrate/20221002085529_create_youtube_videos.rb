class CreateYoutubeVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :youtube_videos do |t|
      t.belongs_to :user, null: false, index: true
      t.string :youtube_id
      t.string :title
      t.text :description
      t.text :thumbnail_url
      t.integer :duration
      t.datetime :published_at
      t.integer :like_count, default: 0
      t.integer :dislike_count, default: 0
      t.timestamps
    end

    add_index :youtube_videos, [:user_id, :youtube_id], unique: true
  end
end
