module Blog
  class Post < Sequel::Model(:blog_post)
    def self.published
      exclude(published_at: nil)
    end
  end
end
