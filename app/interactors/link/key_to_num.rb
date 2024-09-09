module Link
  class KeyToNum < BaseInteractor
    include Codes

    param :key

    def call
      Try {
        key.chars.inject(0) { |acc, c| (acc * LETTERS.size) + LETTERS.index(c) }
      }
        .to_result
    end
  end
end
