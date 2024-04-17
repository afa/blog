class TakeUser
  option :hash

  private

  def take
    acc = Account.where(token: hash).first
    return Failure(:unlogged) unless acc

    Success(acc)
  end
end
