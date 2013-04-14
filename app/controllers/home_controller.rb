class HomeController < ApplicationController
  require 'simple_youtube'
  require 'youtube_it'

  #apikey = 'AI39si4Pr_04oKIc9DGKvMKLr3uGITCKmGGnz2jx-wu2xx_BcTgYEFc5w18FPsRyhVCuJX3xq0My7oojh0LZJHmPoEi7xEnoIQ'

  def index
  	@users = User.all
  	#@playlist = Video.all.map &:ytid
  	playlist_id = Playlist.find_by_name('Pop').ytid.to_s

  	#youtubeit
  	client = YouTubeIt::Client.new(:dev_key => "AI39si4Pr_04oKIc9DGKvMKLr3uGITCKmGGnz2jx-wu2xx_BcTgYEFc5w18FPsRyhVCuJX3xq0My7oojh0LZJHmPoEi7xEnoIQ")
  	playlist_videos = client.playlist(playlist_id)
  	playlist_videos_ids = playlist_videos.videos.map &:unique_id
  	@playlist = playlist_videos_ids
  	@playlist = @playlist.shuffle
  end
  

  #get youtube playlist
  def simple_youtube
  	#simple youtube
  	playlist_feed = Youtube::Standardfeed.find(:scope => 'US', :type => 'top_rated', :params => {:category => 'Music', :"max-results" => '60', :v => '2'})
  	playlist_feed_videos = playlist_feed.videos.map &:id
  	playlist_feed_videos = playlist_feed_videos.map do |str| 
  		#id is located at the end of the response string
  		str = str.split(':').fetch(3)
  	end
  end
  def youtubeit_feed
  	client = YouTubeIt::Client.new
  	playlist_feed = client.videos_by(:most_popular, :categories => [:music], :tags => ["vevo"])
  	playlist_feed_videos = playlist_feed.videos.map &:video_id

  	playlist_feed_videos = playlist_feed_videos.map do |str| 
  		#id is located at the end of the response string
  		str = str.split(':').fetch(3)
  	end
  end

end
