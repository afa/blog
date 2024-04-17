module Link
  class CreateContract < BaseContract
    schema do
      required(:url).filled(Types::String)
    end
  end
end
