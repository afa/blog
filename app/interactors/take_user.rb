class TakeUser < BaseInteractor
  option :hash

  def call
    acc = Account.where(token: hash).first
    return Failure(:unlogged) unless acc

    Success(acc)
  end
end
