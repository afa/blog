module Link
  class Create < BaseInteractor
    option :account
    option :params
    option :contract, default: -> { Link::CreateContract.new }

    FIRST_LETTER =
      %w[A B C D E F G H J K L M N P Q R S T U V W X Y Z a b c d e f g h j k m n o p q r s t u v w x y z].freeze
    LETTERS = %w[2 3 4 5 6 7 8 9] + FIRST_LETTER

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
      url = hash[:url]
      lnk = FastLink.where(url:).first
      return Success(lnk) if lnk

      user = account.user
      url_id = mk_url

      lnk = FastLink.create(url:, author_id: user.id, url_key: url_id)
      return Failure(:cant_create) unless lnk

      Success(lnk)
    end

    def mk_url
      # начинается с буквы, без  1, l, i, I, O, 0
      last_id = FastLink.order(:id).last&.id || 0
      frst = last_id % FIRST_LETTER.size
      last_id /= FIRST_LETTER.size
      ids = []
      until last_id.zero?
        ids << (last_id % LETTERS.size)
        last_id /= LETTERS.size
      end
      FIRST_LETTER[frst] + ids.map { |i| LETTERS[i] }.join
    end
  end
end
