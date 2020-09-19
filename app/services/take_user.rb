class TakeUser
  include Dry::Transaction

  step :take

  private

  def take(hash:)
    acc = Account.where(token: hash).first
    return Failure(:unlogged) unless acc

    Success(acc)
  end
end
