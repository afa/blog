require 'bundler/setup'
Bundler.require(:default)

require './boot'

map '/l' do
  run LinkManager
end

# map '/c' do
#   run CitateManager
# end

map '/b' do
  run BlogManager
end

map '/' do
  run AppManager
end
