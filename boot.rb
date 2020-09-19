require 'sinatra/cookies'
# db connect
db_url = File.open('./config/database.yml', 'r') { |f| YAML.safe_load(f.read) }[ENV['RACK_ENV']]['url']
DB = Sequel.connect(db_url)
# db_url = File.open('./config/database.yml', 'r') { |f| YAML.safe_load(ERB.new(f.read).result) }

# autoload classes (app/)
def autold(path)
  $LOAD_PATH << path if File.directory?(path)
  Dir[File.join(path, '**/*.rb')].each do |f|
    fl = f.delete_suffix('.rb').delete_prefix(path + '/').delete_prefix(path)
    autoload(fl.split('/').map { |m| m.split('_').map(&:capitalize).join }.join('::').to_sym, fl)
  end
end
Dir['./app/*'].each { |p| autold(p) }
