# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'DEFAULT USERS'

user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name

user2 = User.find_or_create_by_email :name => 'Dev User', :email => 'devuser@example.com', :password => 'devuser', :password_confirmation => 'devuser'
puts 'user: ' << user2.name

puts 'DEFAULT PLAYLIST'

playlist1 = Playlist.find_or_create_by_ytid :ytid => 'PLhM36HkgFAEbz26ztdP_ePVXUMqix_sVt', :name => 'Pop'
puts 'playlist: ' << playlist1.name