module Sync
  class Source < Sequel::Model(:sync_source)
    one_to_many :sessions, class: 'Sync::Session'
    one_to_one :structure, class: Sync::Structure
  end
end
