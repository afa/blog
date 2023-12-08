class AppManager < Sinatra::Base
  helpers Sinatra::Cookies
  get '/login' do
    LoginView.new.call(account: nil).to_s
  end

  post '/login' do
    LocateUser.new.call(params) do |m|
      m.success do |hash|
        cookies[:user] = hash
        redirect '/'
      end
      m.failure do
        redirect '/login'
      end
    end
  end

  post '/logout' do
    cookies[:user] = nil
    redirect '/'
  end

  get '/' do
    TakeUser.new.call(hash: cookies[:user]) do |m|
      m.success { |acc| DashboardView.new.call(account: acc, params: params).to_s }
      m.failure { redirect '/login' }
    end
  end
end
