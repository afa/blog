class LocateUser
  include Dry::Transaction

  step :locate

  private

  def locate(params)
    uname = params['user']
    acc = Account.where(login: uname).first
    return Failure(:not_found) unless acc

    pass = BCrypt::Password.new(acc.encrypted_password)
    return Failure(:not_found) unless pass == params['password']

    Success(acc.token)
  end
end
