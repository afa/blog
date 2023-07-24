require 'sinatra/cookies'
require 'logger'
require 'sequel'
require_relative './app'
App.logger = Logger.new('log/processing.log', 'monthly')
App.logger.level = Logger::INFO
App.logger.info('App start')

begin
  App.config = YAML.load_file('config.yml') || {}
rescue Exception => e
  App.logger.error("config not loaded with #{e.message}")
  raise
end

begin
  db_url = App.config['db'] || ENV['DATABASE_URL'] || 'postgres://localhost/app'
  App.db = Sequel.connect(db_url)
rescue Exception => e
  App.logger.error("db not connected with #{e.message}")
  raise
end

begin
  App.ext_db ||= {}
  App.config.fetch('ext_db', {}).each do |k, v|
    App.ext_db[k.to_sym] = Sequel.connect(v)
  end
rescue Exception => e
  App.logger.error("ext_db not connected with #{e.message}")
  raise
end
# db_url = File.open('./config/database.yml', 'r') { |f| YAML.safe_load(ERB.new(f.read).result) }

# autoload classes (app/)
def autold(path)
  $LOAD_PATH << path if File.directory?(path)
  files = Dir[File.join(path, '**/*.rb')].map do |f|
    f.delete_suffix('.rb').delete_prefix(path + '/').delete_prefix(path).split('/')
  end.sort_by(&:size)
  flist = files.inject([]) { |ar, i| ar << i.dup }
  classes = flist.map { |lst| lst.pop.split('_').map(&:capitalize).join }
  mods = flist.map do |ar|
    ar.map { |i| i.split('_').map(&:capitalize).join }
  end
  classes.each_with_index do |cl, idx|
    if mods[idx].empty?
      autoload(cl.to_sym, files[idx].join('/'))
      next
    end
    m = mods[idx].inject(Object) do |rez, md|
      unless rez.const_defined?(md)
        rez.const_set(md, Module.new)
      end
      rez.const_get(md)
    end
    m.autoload(cl.to_sym, files[idx].join('/'))
  end
end
Dir['./app/*'].each { |p| autold(p) }


