module Link
  class Create
    include Dry::Transaction

    FIRST_LETTER = %w[A B C D E F G H J K L M N P Q R S T U V W X Y Z a b c d e f g h j k m n o p q r s t u v w x y z]
    LETTERS = %w[2 3 4 5 6 7 8 9] + FIRST_LETTER

    check :valid
    step :record
    step :link

    private

    def valid(account:, params:)
      return false unless account

      return false unless account.id

      return false unless account.id.positive?

      return false unless params['url']

      return false if params['url'].strip.empty?

      true
    end

    def record(account:, params:)
      url = params['url'].strip
      lnk = FastLink.where(url: url).first
      return Success(lnk) if lnk

      user = account.user
      url_id = mk_url

      lnk = FastLink.create(url: url, author_id: user.id, url_key: url_id)
      return Failure(:cant_create) unless lnk

      Success(instance: lnk, params: params)
    end

    def link(instance:, params:)
      Success(instance)

    end

    def mk_url
      # начинается с буквы, без  1, l, i, I, O, 0
      last_id = FastLink.order(:id).last&.id || 0
      frst = last_id % FIRST_LETTER.size
      last_id = last_id / FIRST_LETTER.size
      ids = []
      until last_id.zero?
        ids << last_id % LETTERS.size
        last_id = last_id / LETTERS.size
      end
      FIRST_LETTER[frst] + ids.map { |i| LETTERS[i] }.join
    end
  end
end
