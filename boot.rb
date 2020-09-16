require 'sinatra/cookies'
def autold(path)
  $LOAD_PATH << path if File.directory?(path)
  Dir[File.join(path, '**/*.rb')].each do |f|
    fl = f.delete_suffix('.rb').delete_prefix(path + '/').delete_prefix(path)
    autoload(fl.split('/').map { |m| m.split('_').map(&:capitalize).join }.join('::').to_sym, fl)
  end
end
Dir['./app/*'].each { |p| autold(p) }

# views
# autoload(:App, 'app')
# autoload(:Parts, 'parts')
# autoload(:LinkManager, 'link_manager')
# autoload(:ApplicationView, 'application_view')
# autoload(:DashboardView, 'dashboard_view')
# autoload(:LoginView, 'login_view')

# services
# autoload(:TakeUser, 'take_user')
# autoload(:LocateUser, 'locate_user')

