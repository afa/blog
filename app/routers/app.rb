class App < Sinatra::Base
  helpers Sinatra::Cookies
  get '/' do
    user = TakeUser.new.call(hash: cookies[:user]).value_or(nil)
    DashboardView.new.call(user: user, params: params).to_s
  end

  get '/login' do
    LoginView.new.call.to_s
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

  delete '/logout' do
    cookies[:user] = nil
    redirect '/'
  end
end
