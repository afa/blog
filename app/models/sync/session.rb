module Sync
  class Session < Sequel::Model(:sync_session)
    many_to_one :source, class: 'Sync::Source'
  end
end
