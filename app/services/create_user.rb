class CreateUser
  include Dry::Transaction

  check :validate
  step :model

  private

  def validate(first_name:, last_name: nil)
    return false if first_name.to_s.empty?

    true
  end

  def model(first_name:, last_name: nil)
    u = User.create(first_name: first_name, last_name: last_name)
    return Failure(u.errors) unless u.exists?

    Success(u)
  end
end
