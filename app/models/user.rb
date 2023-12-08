class User < Sequel::Model(:user)
  one_to_many :accounts
  one_to_many :links, key: :author_id, class: FastLink
end
