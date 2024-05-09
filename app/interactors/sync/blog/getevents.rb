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

      PROCESS_FIELDS_RULES = {
          /^prop_([1234567890]+)_value$/ => ->(val) { URI.decode_www_form_component(val) },
        /^events_([1234567890]+)_eventtime$/ => ->(val) { DateTime.strptime(val, '%Y-%m-%d %H:%M:%S') },
        /^events_([1234567890]+)_subject$/ => ->(val) { URI.decode_www_form_component(val) },
        /^events_([1234567890]+)_event$/ => ->(val) { URI.decode_www_form_component(val) }
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
          .bind { |rz| convert_fields(rz, PROCESS_FIELDS_RULES) }
          .bind { |rz| Sync::Blog::PostConvert.call(data: rz, rules: POST_PROCESS_RULES) }
      end

      private

      def convert_fields(data, rules)
        Try {
          data.each_with_object({}) { |(k, f), obj|
            m = rules.find { |rexp, l| rexp =~ k }
            obj[k] = m ? m[1].call(f) : f
          }
        }.to_result
      end
    end
  end
end
