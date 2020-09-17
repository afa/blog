class TakeUser
  include Dry::Transaction

  step :take

  private

  def take(hash:)
    Failure(nil)
  end
end
