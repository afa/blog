class FastLinkOption < Sequel::Model(:fast_link_option)
  many_to_one :fast_links
end
