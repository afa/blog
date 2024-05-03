module Sync
  module Blog
    class SyncronizedChunkRepository < BaseRepository
      option :cache_handler, default: -> { Sync::Blog::SyncronizedChunkInstanceCache.new }
      option :lasT_sync, default: -> {}

      def all
      end

      def find(key)
      end

      private
    end
  end
end
