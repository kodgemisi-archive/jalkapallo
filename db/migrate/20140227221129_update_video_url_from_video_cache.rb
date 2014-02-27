class UpdateVideoUrlFromVideoCache < ActiveRecord::Migration
  def change
    change_table :video_caches do |t|
      t.change :video_url, :text
    end
  end
end
