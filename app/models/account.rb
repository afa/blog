class Account < Sequel::Model(DB[:account])
  many_to_one :user
end
