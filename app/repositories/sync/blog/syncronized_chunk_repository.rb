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
        events = yield merge_props(data['events'], data['props'])
        refresh_cache(events)
        # cached_data
      end

      def find(key); end

      private

      def merge_props(events, props)
        Try {
          idx = props.group_by { |hsh| hsh['itemid'] }
          events.each_with_object([]) do |event, obj|
            obj << event
            if idx.key?(event['itemid'])
              obj.last.merge!({ 'props' => idx[event['itemid']].map { |item| item.slice('name', 'value') } })
            end
          end
        }
          .to_result
      end
    end
  end
end
