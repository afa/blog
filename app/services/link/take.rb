module Link
  class Take
    include Dry::Transaction

    step :take

    private

    def take(url_id:)
      link = FastLink.published.where(url_key: url_id).first
      return Failure(:not_found) unless link

      Success(link.url)
    end
  end
end
