require 'digest'

module Sync
  module Protocol
    module Blog
      class Connect < BaseInteractor
        POST_PROCESS_RULES = {
          'access' => /^access_([1234567890]+)$/,
          'frgrp' => {
            /^frgrp_([1234567890]+)_sortorder$/ => 'sortorder',
            /^frgrp_([1234567890]+)_name$/ => 'name'
          }
        }.freeze

        option :source
        option :request_handler, default: -> { Sync::Protocol::Blog::Request }

        def call
          login
        end

        private

        def login
          challenge = yield Sync::Protocol::Blog::PrepareChallenge.call(source:, request_handler:)
          payload = { 'mode' => 'login' }.merge(challenge)
          request_handler
            .call(payload, source:)
            .bind { |rz| Sync::Protocol::Blog::PostConvert.call(data: rz, rules: POST_PROCESS_RULES) }
        end
      end
    end
  end
end
