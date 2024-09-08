module Sync
  class Structure < Sequel::Model(:sync_structure)
    one_to_one :source, class: Sync::Source
  end
end
