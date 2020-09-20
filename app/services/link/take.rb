module Link
  class Take
    include Dry::Transaction

    step :take

    private

    def take(url_id:)
      link = FastLink.where(url_id: url_id).first
      return Failure(:not_found) unless link

      Success(link.url)
    end
  end
end
