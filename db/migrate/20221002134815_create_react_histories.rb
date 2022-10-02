class CreateReactHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :react_histories do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :youtube_video, null: false, index: true
      t.integer :react_type, null: false, default: 0
      t.timestamps
    end

    add_index :react_histories, [:user_id, :youtube_video_id], unique: true
  end
end
