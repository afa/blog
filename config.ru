require 'bundler/setup'
Bundler.require(:default)

require './boot'

map '/' do
  run App
end

map '/l' do
  run LinkManager
end

# map '/c' do
#   run CitateManager
# end

map '/b' do
  run BlogManager
end
