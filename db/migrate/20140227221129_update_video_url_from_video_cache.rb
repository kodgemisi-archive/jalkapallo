class UpdateVideoUrlFromVideoCache < ActiveRecord::Migration
  def up
    change_column :video_caches, :video_url, :text
  end

  def down
    change_column :video_caches, :video_url, :string
  end
end
