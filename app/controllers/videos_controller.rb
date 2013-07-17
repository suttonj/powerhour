require 'open-uri'
require 'nokogiri'

class VideosController < ApplicationController
  protect_from_forgery

  def index
  	@videos = Array.new
  	(0..9).each do |page|
	  	doc = Nokogiri::HTML(open("http://www.billboard.com/charts/hot-100?page=#{page}"))
		titles = Array.new
		artists = Array.new
		
		doc.xpath('//article/header/h1')[0..9].each do |title|
			titles.push(title.text)
		end
		doc.xpath('//article/header/p/a')[0..9].each do |artist|
			artists.push(artist.text)
		end

		(0..9).each do |index| 
			if !titles[index].nil? and !artists[index].nil?
				video = { :title => titles[index], :artist => artists[index]}
				@videos.push(video)
			end
		end

		get_video_ids(@videos)
	end

  end

  private

  def get_video_ids(meta_videos)
  	@video_ids = Array.new
  	meta_videos.each do |metavid|
  		query = metavid[:title].split(' ').join('+') << '+' << metavid[:artist].split(' ').join('+') << '+official+video'
  		url = "https://www.googleapis.com/youtube/v3/search?part=snippet&order=relevance&q=#{query}&type=video&key=#{ENV['API_KEY2']}"
  		response = HTTParty.get(url)
  		search_results = JSON.parse(response.body)
  		puts search_results["items"][0]["id"]["videoId"]
  		#@video_ids.push(search_results["items"][0]["id"]["videoId"])
  	end
  end

end