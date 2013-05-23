class PlaylistsController < ApplicationController
  protect_from_forgery

  #after_filter :flash_to_headers
  before_filter :extract_id

  def search
  	#@playlist = get_playlist_from_youtube(params[:id])
	@playlist = simple_youtube(@parsed_id)
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
  	@playlist_exists = Playlist.exists?(@parsed_id)
	if @playlist_exists
		@message = "Playlist exists in the database"
		ytplaylist = simple_youtube(@parsed_id)
		if ytplaylist.nil?
			@output = "layouts/error"
			@message = "Playlist may have been deleted from Youtube"
			@playlist = nil
		else
			@output = "layouts/placeholder"
			@playlist = ytplaylist
		end
	
	else	
		ytplaylist = simple_youtube(@parsed_id)

	 	if !ytplaylist.nil? 
				playlist_record = Playlist.new( :ytid => @parsed_id, :name => @playlistTitle )
	    	
	    	if playlist_record.save
	    		@message = "Success!"
	    		@playlist_record = Playlist.find_by_ytid(@parsed_id)
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

  	def extract_id
  		@parsed_id = params[:id]
  		if is_url(params[:id]) 
  			url_params = params[:id].split('?').second
  			if url_params.include? "list"
  				@parsed_id = url_params.split('=').second
  			else
  				@parsed_id = params[:id]
  			end
  		else
  			@parsed_id = params[:id]
  		end
  
  	end

  	def is_url(id) 
  		if id.include? "youtube.com"
  			return true
  		else
  			return false
  		end
  	end

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
