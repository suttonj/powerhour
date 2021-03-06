class VideosController < ApplicationController
  require 'open-uri'
  require 'nokogiri'

  protect_from_forgery
  
  before_filter :authenticate, :except => [:show, :list]

  def index
    #electronic
    genre = "electronic"
    beatport = get_beatport()
    officialcharts = get_official_charts(genre)
    @videos = beatport + officialcharts
    save_video_info(@videos, genre)
    #hot
    genre = "hot"
    @videos = get_billboard(genre)
	  save_video_info(@videos, genre)
  end


  def show 
  	@video = Video.find(params[:id])

  end

  def list
  	top60 = Video.find_all_by_genre(params[:genre]).first(60)
    ytid_list = top60.map do |video|
        video = video.ytid
    end
    
    @playlist = ytid_list.reverse
    case params[:genre]
    when 'electronic'
      @playlistTitle = "Top Electronic Videos"
    when 'hot'
      @playlistTitle = "Billboard Top-100"
    end

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
  			#puts title.text 
        titles.push(title.text)
  		end
  		doc.xpath('//article/header/p/a')[0..9].each do |artist, index|
  			 puts artist.text 
         if artist.text.nil?
            artists.push(' ');
         else
            artists.push(artist.text)
  		   end
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

  def get_beatport()
    url = "http://www.beatport.com/top-100"

    @videos = Array.new
    
    doc = Nokogiri::HTML(open(url))
    titles = Array.new
    artists = Array.new
    
    doc.css('tr.track-grid-content').each do |track|
      #puts "TRACK --- "
      links = track.xpath('td')
      title = links[3]
      artist = links[4]
      
      title = title.text.gsub(/\((.*)\)/,'')
      artist = artist.text.gsub(/\,/, '')
      #puts title << ' -- ' << artist

      titles.push(title)
      artists.push(artist)

    end

    #puts "artists: " << artists.count << ", titles: " << titles.count
    (0..60).each do |index| 
      if !titles[index].nil? and !artists[index].nil?
        video = { :title => titles[index], :artist => artists[index] }
        @videos.push(video)
      end
    end
    
    puts "VIDEO COUNT = " << @videos.count
    return @videos
  end

  def get_official_charts(genre)
    #case genre
    #when "edm", "electronic"
      url = "http://www.officialcharts.com/dance-charts/"
    #end

    @videos = Array.new
    doc = Nokogiri::HTML(open(url))
    titles = Array.new
    artists = Array.new

    doc.css('.infoHolder > h3').each do |title|
      puts title.text 
      titles.push(title.text)
    end
    doc.css('.infoHolder > h4').each do |artist|
      puts artist.text
      artists.push(artist.text)
    end

    puts "artists: " << artists.count << ", titles: " << titles.count
    (0..40).each do |index| 
      if !titles[index].nil? and !artists[index].nil?
        video = { :title => titles[index], :artist => artists[index] }
        @videos.push(video)
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
      if !metavid.nil? and !metavid[:title].nil?
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
    			if view_count.to_i > 50000
    			#if search_results["items"][0]["snippet"]["title"].downcase.include? metavid[:title].downcase
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

end