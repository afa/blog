module Sync
  module Blog
    class ImportChunk < BaseInteractor
      # загружает очередную порцию жж записей, берет стратегию и протокол из source, параметры для порции из last_session
      option :source
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
            strategy.call(data)
          }
          .alt_map { |err|
            logger(err)
          }
          .fmap { |_|
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
            cache_handler: Sync::Blog::SyncronizedChunkInstanceCache.new
          )
        }
          .to_result
      end

      def logger(err)
        pp err
      end
    end
  end
end
