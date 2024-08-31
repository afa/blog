module Sync
  class Source < Sequel::Model(:sync_source)
    one_to_many :sessions, class: 'Sync::Session'
  end
end
