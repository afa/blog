class CreateAccount < BaseInteractor
  option :user
  option :login
  option :pass

  def call
    yield validate
    account = yield model
    yield token(account)
    yield password(account)
    yield store(account)
  end

  # check :validate
  # step :model
  # step :token
  # step :password
  # step :store

  private

  def validate
    return Failure() unless user

    return Failure() if pass.to_s.empty?

    Success()
  end

  def model
    account = Account.new(user_id: user.id, login:)
    Success(account)
  end

  def token(account)
    16.times do
      t = SecureRandom.hex
      unless Account[token: t]
        account.token = t
        return Success()
      end
    end
    Failure(:no_unique_token_generated)
  end

  def password(account)
    account.encrypted_password = BCrypt::Password.create(pass)
    Success()
  end

  def store(account)
    account.save_changes
    return Failure(errors: account.errors) if account.modified? || !account.exists?

    Success(account)
  end
end
