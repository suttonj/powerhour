class Video < ActiveRecord::Base
  attr_accessible :name, :ytid, :genre
  validates_uniqueness_of :ytid
end
