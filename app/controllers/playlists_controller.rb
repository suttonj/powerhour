class PlaylistsController < ApplicationController
  
  def search

  	@playlist = get_playlist_from_youtube(params[:id])

  	respond_to do |format|
      format.js 
    end
  end

end
