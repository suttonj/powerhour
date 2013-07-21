class VideosController < ApplicationController
  require 'open-uri'
  require 'nokogiri'

  protect_from_forgery

  def index
  	#genre = params[:genre]
  	@videos = get_billboard('hot')
	save_video_info(@videos, 'hot')
  end


  def show 
  	@video = Video.find(params[:id])

  end

  def list
  	top60 = Video.find_all_by_genre("hot").first(60)
    ytid_list = top60.map do |video|
        video = video.ytid
    end
    
    @playlist = ytid_list.reverse
    @playlistTitle = "Billboard Top-100"

    if @playlist.nil? 
		#flash[:error] = "Unable to find playlist on Youtube"
		@output = "layouts/error"
	else
		@output = "layouts/placeholder"
	end

	respond_to do |format|
		format.js
	end

  end

  private

  def get_billboard(genre)
  	case genre
  	when "hot"
  		url = "http://www.billboard.com/charts/hot-100"
  	when "electronic"
  		url = "http://www.billboard.com/charts/dance-electronic-songs"
  	end

  	@videos = Array.new
  	(0..9).each do |page|
	  	doc = Nokogiri::HTML(open(url + "?page=#{page}"))
		titles = Array.new
		artists = Array.new
		
		doc.xpath('//article/header/h1')[0..9].each do |title|
			titles.push(title.text)
		end
		doc.xpath('//article/header/p')[0..9].each do |artist|
			artists.push(artist.text)
		end

		(0..9).each do |index| 
			if !titles[index].nil? and !artists[index].nil?
				video = { :title => titles[index], :artist => artists[index] }
				@videos.push(video)
			end
		end
	end
	return @videos
  end

  def save_video_info(meta_videos, genre)
  	if meta_videos
  		Video.where(:genre => genre).destroy_all
  	end

  	count = 0
  	meta_videos.each do |metavid|
  		query = URI.encode(metavid[:title].split(' ').join('+') << '+' << metavid[:artist].split(' ').join('+') << '+official+video')
  		search_url = "https://www.googleapis.com/youtube/v3/search?part=snippet&order=relevance&q=#{query}&type=video&key=#{ENV['API_KEY2']}"
  		response = HTTParty.get(search_url)
  		search_results = JSON.parse(response.body)
  		if !search_results["items"].nil?
  			puts search_results["items"][0]["id"]["videoId"]
  			name = search_results["items"][0]["snippet"]["title"]
  			ytid = search_results["items"][0]["id"]["videoId"]
  			
  			stats_url = "https://www.googleapis.com/youtube/v3/videos?part=statistics&id=#{ytid}&key=#{ENV['API_KEY2']}"
  			stats_results = JSON.parse(HTTParty.get(stats_url).body)
  			puts stats_results["items"][0]["statistics"]["viewCount"]
  			view_count = stats_results["items"][0]["statistics"]["viewCount"]
  			if view_count.to_i > 600000
  				video = Video.new(:name => name, :ytid => ytid, :genre => genre)
  				video.save
  				puts "#{name} saved"
  				count = count + 1

  				metavid[:ytid] = ytid
  				metavid[:viewcount] = view_count
  				metavid[:pos] = count
  			end
  		end
  	end
  end

end