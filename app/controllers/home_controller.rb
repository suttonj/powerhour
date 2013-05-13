class HomeController < ApplicationController
  require 'youtube_it'
  require 'simple_youtube'

  def index
  	@users = User.all
  	#@playlist = Video.all.map &:ytid
  	playlist_id = Playlist.find_by_name('Pop').ytid.to_s
    @playlists = Playlist.all
  	#youtubeit
  	#get_playlist_from_youtube(playlist_id)

    #simple_youtube
    simple_youtube(playlist_id)
  end

end
