module Sync
  module Blog
    class Syncitems < BaseInteractor
      POST_PROCESS_RULES = {
        'sync_items' => {
          /^sync_([1234567890]+)_item$/ => 'item',
          /^sync_([1234567890]+)_action$/ => 'action',
          /^sync_([1234567890]+)_time$/ => 'time'
        }
      }.freeze

      option :source
      option :last_sync, default: -> { false }
      option :request_handler, default: -> { Sync::Blog::Request }

      def call
        challenge = yield Sync::Blog::PrepareChallenge.call(source:)
        payload = { 'mode' => 'syncitems', 'ver' => '1' }
                  .tap { |pl| pl.merge!('lastsync' => last_sync.strftime('%Y-%m-%d %H:%M:%S')) if last_sync }
                  .merge(challenge)
        request_handler
          .call(payload, source:)
          .bind { |rz| Sync::Blog::PostConvert.call(data: rz, rules: POST_PROCESS_RULES) }
      end
    end
  end
end
