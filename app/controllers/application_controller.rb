class ApplicationController < ActionController::Base
  protect_from_forgery

  def get_playlist_from_youtube(playlist_id)
  	client = YouTubeIt::Client.new(:dev_key => ENV['API_KEY'])
  	playlist_videos = client.playlist(playlist_id, :max_results => 60)
  	playlist_videos_ids = playlist_videos.videos.map &:unique_id
  	
  	@playlistTitle = playlist_videos.title
  	@playlist = playlist_videos_ids.shuffle
  end

  def simple_youtube(playlist_id)
    #simple youtube
    begin
      playlist_query = Youtube::Playlist.find(:scope => playlist_id, :params => {:"max-results" => '50', :v => '2'})
      playlist_videos = playlist_query.entry.map do |entry|
        entry = entry.group.videoid
      end

      @playlistTitle = playlist_query.title
      @playlist = playlist_videos.shuffle

    rescue
      @playlist = nil
    end
    
  end

end
