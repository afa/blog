require 'sinatra/cookies'
# db connect
db_url = File.open('./config/database.yml', 'r') { |f| YAML.safe_load(f.read) }[ENV['RACK_ENV'] || 'development']['url']
DB = Sequel.connect(db_url)
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
