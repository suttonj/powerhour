class PlaylistsController < ApplicationController
  protect_from_forgery

  #after_filter :flash_to_headers

  def search
  	#@playlist = get_playlist_from_youtube(params[:id])
	@playlist = simple_youtube(params[:id])
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

  def create
  	@playlist_exists = Playlist.exists?(params[:id])
	if @playlist_exists
		@message = "Playlist exists in the database"
		ytplaylist = simple_youtube(params[:id])
		if ytplaylist.nil?
			@output = "layouts/error"
			@message = "Playlist may have been deleted from Youtube"
			@playlist = nil
		else
			@output = "layouts/placeholder"
			@playlist = ytplaylist
		end
	
	else	
		ytplaylist = simple_youtube(params[:id])

	 	if !ytplaylist.nil? 
				playlist_record = Playlist.new( :ytid => params[:id], :name => @playlistTitle )
	    	
	    	if playlist_record.save
	    		@message = "Success!"
	    		@playlist_record = Playlist.find_by_ytid(params[:id])
	    	else
	    		@message = "Could not save the playlist."
	    	end
		    
		    @output = "layouts/placeholder"
		else 
			@message = "Error - couldn't find the playlist on youtube"
			@output = "layouts/error"
		end

		@playlist = ytplaylist
	end

	respond_to do |format|
		format.js
	end
  end

  def index

  end

  private

  	def flash_to_headers
        return unless request.xhr?
        response.headers['X-Message'] = flash_message
        response.headers["X-Message-Type"] = flash_type.to_s

        flash.discard # don't want the flash to appear when you reload page
    end

	def flash_message
	    [:error, :warning, :notice].each do |type|
	        return flash[type] unless flash[type].blank?
	    end
	end

	def flash_type
	    [:error, :warning, :notice].each do |type|
	        return type unless flash[type].blank?
	    end
	end
end
