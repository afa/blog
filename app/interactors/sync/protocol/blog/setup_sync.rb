module Sync
  module Protocol
    module Blog
      class SetupSync < BaseInteractor
        option :source

        def call
          parent = yield find_parent.or_fmap { nil }
          params = yield make_params(parent)
          make_session(parent, params)
        end

        private

        def find_parent
          Maybe(Sync::Session.where(tail_id: nil, kind: source.kind).first)
            .to_result
        end

        def make_params(session)
          Try {
            # sync_options -> last_sync
            if session
              { 'sync_options' => { 'last_sync' => session.timestamp } }
            else
              {}
            end
          }
            .to_result
        end

        def make_session(head, params)
          Try {
            App.db.transaction do
              session = Sync::Session.create({ kind: source.kind, source_id: source.id }.merge(params))
              if head
                head.tail_id = session.id
                head.save_changes
              end
              session
            end
          }
            .to_result
        end
      end
    end
  end
end
