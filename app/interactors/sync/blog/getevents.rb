module Sync
  module Blog
    class Getevents < BaseInteractor
      POST_PROCESS_RULES = {
        'events' => {
          /^events_([1234567890]+)_itemid$/ => 'itemid',
          /^events_([1234567890]+)_eventtime$/ => 'eventtime',
          /^events_([1234567890]+)_event$/ => 'event',
          /^events_([1234567890]+)_security$/ => 'security',
          /^events_([1234567890]+)_allowmask$/ => 'allowmask',
          /^events_([1234567890]+)_subject$/ => 'subject',
          /^events_([1234567890]+)_poster$/ => 'poster',
          /^events_([1234567890]+)_anum$/ => 'anum',
          /^events_([1234567890]+)_url$/ => 'url'
        },
        'props' => {
          /^prop_([1234567890]+)_itemid$/ => 'itemid',
          /^prop_([1234567890]+)_name$/ => 'name',
          /^prop_([1234567890]+)_value$/ => 'value'
        }
      }.freeze

      option :source
      option :last_sync, default: -> { false }
      option :request_handler, default: -> { Sync::Blog::Request }

      def call
        challenge = yield Sync::Blog::PrepareChallenge.call(source:, request_handler:)
        payload = { 'mode' => 'getevents', 'ver' => '1', 'selecttype' => 'syncitems' }
                  .tap { |pl| pl.merge!('lastsync' => last_sync.strftime('%Y-%m-%d %H:%M:%S')) if last_sync }
                  .merge(challenge)
        request_handler
          .call(payload, source:)
          .bind { |rz| Sync::Blog::PostConvert.call(data: rz, rules: POST_PROCESS_RULES) }
      end
    end
  end
end
