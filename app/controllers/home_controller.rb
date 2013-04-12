class HomeController < ApplicationController

  def index
  	@users = User.all
  	@playlist = Video.all.map &:ytid
  	
  end
  
end
