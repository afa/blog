module Parts
  class Post < Dry::View::Part
    def body
      value.body
    end

    def date
      published_at&.to_date
    end

    def title
      value.title
    end

    def to_s
      render :post, post: self
    end
  end
end
