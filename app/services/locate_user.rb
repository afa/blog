class LocateUser < BaseInteractor
  param :params

  private

  def locate
    uname = params['user']
    acc = Account.where(login: uname).first
    return Failure(:not_found) unless acc

    pass = BCrypt::Password.new(acc.encrypted_password)
    return Failure(:not_found) unless pass == params['password']

    Success(acc.token)
  end
end
