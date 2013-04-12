class Video < ActiveRecord::Base
  attr_accessible :name, :ytid
  validates_uniqueness_of :ytid
end
