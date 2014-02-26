class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :video_name
      t.string :video_description
      t.string :youtube_url
      t.integer :start_time
      t.integer :stop_time
      t.integer :end_time
      t.boolean :result

      t.timestamps
    end
  end
end
