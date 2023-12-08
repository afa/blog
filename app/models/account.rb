class Account < Sequel::Model(:account)
  many_to_one :user
end
