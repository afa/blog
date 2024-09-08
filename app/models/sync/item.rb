module Sync
  class Item < Sequel::Model(:sync_item)
    one_to_many :attributes
    many_to_one :session, class: Sync::Session
    many_to_one :structure, class: Sync::Structure
  end
end
