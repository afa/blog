module Parts
  class Post < Dry::View::Part
    def body
      value.body
    end

    def date
      published_at&.to_date
    end
  end
end
