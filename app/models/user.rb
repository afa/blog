class User < Sequel::Model(DB[:user])
  one_to_many :accounts
end
