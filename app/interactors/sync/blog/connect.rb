require 'digest'

module Sync
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
      option :request_handler, default: -> { Sync::Blog::Request }

      def call
        login
      end

      private

      def login
        challenge = yield Sync::Blog::PrepareChallenge.call(source:)
        payload = { 'mode' => 'login' }.merge(challenge)
        request_handler
          .call(payload, source:)
          .bind { |rz| Sync::Blog::PostConvert.call(data: rz, rules: POST_PROCESS_RULES) }
      end
    end
  end
end
