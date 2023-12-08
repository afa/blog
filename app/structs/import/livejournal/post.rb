require 'dry-struct'
module Types
  include Dry.Types()
end

module Import
  module Livejournal
    class Post < Dry::Struct
      attribute :itemid, Types::Coercible::Integer
      attribute :body, Types::String
      attribute :title, Types::String
      attribute :origin_url, Types::String
      attribute :reply_count, Types::Coercible::Integer
      attribute :commentable, Types::Params::Bool
      attribute :timestamp, Types::Coercible::Integer
      attribute :ditemid, Types::Coercible::Integer
      attribute :anum, Types::Coercible::Integer
      attribute :props, Types::Hash
      attribute :eventtime, Types::String
      attribute :logtime, Types::String
    end
  end
end
