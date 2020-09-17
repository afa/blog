class LocateUser
  include Dry::Transaction

  step :locate

  private

  def locate(params)
    Failure(nil)
  end
end
