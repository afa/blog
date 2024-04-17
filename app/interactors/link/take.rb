module Link
  class Take < BaseInteractor
    param :url_id

    def call
      Maybe(FastLink.published.where(url_key: url_id).first).to_result
    end
  end
end
