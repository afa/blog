module Sync
  module Blog
    class ImportChunk < BaseInteractor
      # загружает очередную порцию жж записей, берет стратегию и протокол из source, параметры для порции из
      # last_session
      option :source
      option :cache, default: -> { Sync::Blog::SyncronizedChunkInstanceCache.new }
      # option :last_session

      def call
        # setup params
        # params extracts from session
        # session builded with Sync::Blog::SetupSync, not here
        # select strategy
        # load chunk through repository (via cache handler when required)
        # send to repo source and created session
        # run strategy
        # in strategy update current snapshot and build diffs to previous syncs
        # update current session to process later differences
        session = yield setup
        strategy = yield determine_strategy
        repo = yield repository(session)
        repo
          .all
          .bind { |data|
            strategy.call(session:, data:)
          }
          .alt_map { |err|
            logger(err)
          }
          .fmap { |_|
            stamp = repo
                    .all
                    .value_or({ 'posts' => [] })['posts']
                    .max_by { |item| item['eventtime'] }
                    .fetch('eventtime', nil)
            session.timestamp = stamp&.to_time&.to_i
          }
          .bind { |_|
            save_session(session)
          }
      end

      private

      def setup
        Sync::Protocol::Blog::SetupSync.call(source:)
      end

      def determine_strategy
        Sync::Strategy::SelectStrategy.call(source:)
      end

      def repository(session)
        Try {
          Sync::Blog::SyncronizedChunkRepository.new(
            source:,
            last_sync: session.sync_options['last_sync'],
            cache_handler: cache
          )
        }
          .to_result
      end

      def logger(err)
        App.logger.error err.pretty_inspect
      end

      def save_session(session)
        Try {
          session.save_changes
        }
          .to_result
      end
    end
  end
end
