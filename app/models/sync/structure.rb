module Sync
  class Structure < Sequel::Model(:sync_structure)
    many_to_one :source
  end
end
