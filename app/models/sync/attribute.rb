module Sync
  class Attribute < Sequel::Model(:sync_attribute)
    many_to_one :item, class: Sync::Item
  end
end
