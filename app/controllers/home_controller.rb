class HomeController < ApplicationController
  require 'youtube_it'
  require 'simple_youtube'

  def index
  	@users = User.all
  	#@playlist = Video.all.map &:ytid
  	#playlist_id = Playlist.find_by_name('Pop').ytid.to_s
    @playlists = Playlist.all
  	#youtubeit
  	#get_playlist_from_youtube(playlist_id)

    #simple_youtube
    #simple_youtube(playlist_id)

    #top videos from billboard
    top60 = Video.find_all_by_genre("hot").first(60)
    ytid_list = top60.map do |video|
        video = video.ytid
    end
    
    @playlist = ytid_list.reverse
    @playlistTitle = "Billboard Top-100"
  end

end
