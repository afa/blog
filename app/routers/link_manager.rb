class LinkManager < Sinatra::Base
  get '/' do
    'ok'
  end

  get '/:link_id' do
    p params
    'ok'
  end
end
