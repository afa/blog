module Blog
  class IndexView < ::ApplicationView
    config.template = 'blog/index'

    expose :posts

    private

    def posts(params:)
      Blog::Post.all
    end
  end
end
