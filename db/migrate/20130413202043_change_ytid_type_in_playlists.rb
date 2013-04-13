class ChangeYtidTypeInPlaylists < ActiveRecord::Migration
  def up
  	change_column :playlists, :ytid, :string
  end

  def down
  	change_column :playlists, :ytid, :int
  end
end
