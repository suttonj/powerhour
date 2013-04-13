class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.integer :ytid
      t.string :name

      t.timestamps
    end
  end
end
