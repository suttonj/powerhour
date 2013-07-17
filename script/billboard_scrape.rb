#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'

def start
	doc = Nokogiri::HTML(open('http://www.billboard.com/charts/hot-100?page=0'))
	doc.xpath('//article/head/h1').each do |title|
		puts title.text
	end
end
