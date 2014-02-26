class RemoveValidFromVideoCache < ActiveRecord::Migration
  def change
    remove_column :video_caches, :valid, :boolean
  end
end
