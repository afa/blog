module Sync
  class Session < Sequel::Model(:sync_session)
    plugin :enum

    enum :state, init: 0, parsed: 1, processed: 2

    many_to_one :source, class: 'Sync::Source'
    one_to_many :items, class: Sync::Item
  end
end
