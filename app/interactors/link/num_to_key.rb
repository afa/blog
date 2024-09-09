module Link
  class NumToKey < BaseInteractor
    include Codes

    param :num

    def call
      Try { calc(num).join }.to_result
    end

    private

    def calc(number)
      n = number / LETTERS.size
      k = number % LETTERS.size
      return calc(n) + [LETTERS[k]] if n.positive?

      return [FIRST_LETTER[k]] if k < FIRST_LETTER.size

      [FIRST_LETTER[0], LETTERS[k]]
    end
  end
end
