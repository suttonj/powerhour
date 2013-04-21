class ApplicationController < ActionController::Base
  protect_from_forgery

  def get_playlist_from_youtube(playlist_id)
  	client = YouTubeIt::Client.new(:dev_key => ENV['API_KEY'])
  	playlist_videos = client.playlist(playlist_id)
  	playlist_videos_ids = playlist_videos.videos.map &:unique_id
  	
  	@playlistTitle = playlist_videos.title
  	@playlist = playlist_videos_ids
  	@playlist = @playlist.shuffle
  end

end
