module Link
  class Create
    include Dry::Transaction

    check :valid
    step :create

    private

    def valid(account:, params:)
      true
    end

    def create(account:, params:)
      Failure()
    end
  end
end
