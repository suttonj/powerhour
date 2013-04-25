class Playlist < ActiveRecord::Base
  attr_accessible :name, :ytid

  validates :ytid, :presence => true
end
