dirs = Dir['./app/*']
dirs.each { |p| $LOAD_PATH << p }
autoload(:App, 'app')
autoload(:LinkManager, 'link_manager')
# require './app'
