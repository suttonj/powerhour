class Playlist < ActiveRecord::Base
  attr_accessible :name, :ytid

  validates :ytid, :presence => true, :length => { :in => 12..50 }
  validates_uniqueness_of :ytid
end
