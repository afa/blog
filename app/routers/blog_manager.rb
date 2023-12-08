class BlogManager < Sinatra::Base
  helpers Sinatra::Cookies
  get '/' do
    account = TakeUser.new.call(hash: cookies[:user]).value_or(nil)
    Blog::IndexView.new.call(account: account, params: params).to_s
  end

  get '/:url_id' do
    Link::Take.new.call(url_id: params['url_id']) do |m|
      m.success do |url|
        redirect url
      end
      m.failure do
        redirect '/'
      end
    end
  end

  post '/' do
    account = TakeUser.new.call(hash: cookies[:user]).value_or(nil)
    Link::Create.new.call(account: account, params: params) do |m|
      m.success do |val|
        Link::CreateView.new.call(account: account, link: val).to_s
      end
      m.failure do
        redirect '/'
      end
    end
  end
end
