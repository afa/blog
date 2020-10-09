module Parts
  class Posts < Dry::View::Part
    def index
      render :posts
    end
  end
end
