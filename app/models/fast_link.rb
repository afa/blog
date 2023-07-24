class FastLink < Sequel::Model(:fast_link)
  plugin :enum
  enum :state, init: 0, reserved: 1, published: 2

  many_to_one :author, class: User
  one_to_one :option, class: FastLinkOption
end
