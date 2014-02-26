class CreateVideoCaches < ActiveRecord::Migration
  def change
    create_table :video_caches do |t|
      t.string :youtube_url
      t.string :video_url
      t.boolean :valid

      t.timestamps
    end
  end
end
