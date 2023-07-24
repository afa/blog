class TakeUser
  include Dry::Transaction

  step :take

  private

  def take(hash:)
    acc = Account.where(token: hash).first
    pp acc
    return Failure(:unlogged) unless acc

    pp :ok
    Success(acc)
  end
end
