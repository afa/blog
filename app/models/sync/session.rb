module Sync
  class Session < Sequel::Model(:sync_session)
    plugin :enum

    enum :state, init: 0

    many_to_one :source, class: 'Sync::Source'
  end
end
