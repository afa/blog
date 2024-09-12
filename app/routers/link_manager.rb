class LinkManager < Sinatra::Base
  helpers Sinatra::Cookies
  get '/' do
    account = TakeUser.call(hash: cookies[:user]).value_or(nil)
    Link::IndexView.new.call(account:, params:).to_s
  end

  get '/:id/edit' do
    account = TakeUser.call(hash: cookies[:user]).value_or(nil)
    link = FastLink.where(author_id: account.user.id, id: params['id'].to_i).first
    if link
        Link::EditView.new.call(account:, link:).to_s
    else
      'err'
    end
  end

  put '/:url_id' do
  end

  get '/:url_id/show' do
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
    account = TakeUser.call(hash: cookies[:user]).value_or(nil)
    Link::Create.call(account:, params:) do |m|
      m.success do |val|
        Link::CreateView.new.call(account:, link: val).to_s
      end
      m.failure do
        redirect '/'
      end
    end
  end
end
