module Link
  class Create < BaseInteractor
    extend Codes
    option :account
    option :params
    option :contract, default: -> { Link::CreateContract.new }

    def call
      return Failure(:unauthorized) unless account&.pk

      hash = yield process_params
      record(hash)
    end

    private

    def process_params
      contract.call(params).to_monad
      # return false unless params['url']

      # return false if params['url'].strip.empty?
    end

    def record(hash)
      Try {
        url = hash[:url]
        lnk = FastLink.where(url:).first
        return Success(lnk) if lnk

        user = account.user
        url_str = mk_url

        lnk = FastLink.create(url:, author_id: user.id, url_key: url_str)
        return Failure(:cant_create) unless lnk

        lnk
      }
        .to_result
    end

    def mk_url
      last_id = FastLink.order(:id).last&.id || 0
      Link::NumToKey.call(last_id)
    end
  end
end
