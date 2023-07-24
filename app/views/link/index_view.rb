module Link
  class IndexView < ApplicationView
    config.template = 'links/index'

    expose :links do |params:|
      FastLink.all.to_a
    end
  end
end

