module Sync
  module Blog
    class SyncronizedChunkRepository < BaseRepository
      option :cache_handler, default: -> { Sync::Blog::SyncronizedChunkInstanceCache.new }
      option :lasT_sync, default: -> {}
      option :source

      def_delegators :cache_handler, :cache?, :cached_data, :refresh_cache

      def index; end

      def all
        return cached_data if cache?

        data = yield Sync::Protocol::Blog::Getevents.call(last_sync:, source:)
        refresh_cache(data)
        cached_data
      end

      def find(key); end
    end
  end
end
