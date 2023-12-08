class CreateAccount
  include Dry::Transaction

  check :validate
  step :model
  step :token
  step :password
  step :store

  private

  def validate(user:, login:, pass:)
    return false unless user

    return false if pass.to_s.empty?

    true
  end

  def model(user:, login:, pass:)
    m = Account.new(user_id: user.id, login: login)
    Success(account: m, pass: pass)
  end

  def token(account:, pass:)
    16.times do
      t = SecureRandom.hex
      unless Account[token: t]
        account.token = t
        return Success(account: account, pass: pass)
      end
    end
    Failure(:no_unique_token_generated)
  end

  def password(account:, pass:)
    account.encrypted_password = BCrypt::Password.create(pass)
    Success(account: account)
  end

  def store(account:)
    account.save
    return Failure(errors: account.errors) if account.modified? || !account.exists?

    Success(account)
  end
end
