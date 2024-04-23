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

      option :config, default: -> { App.config.dig('sync', 'blog') }
      option :request_handler, default: -> { Sync::Blog::Request }

      def call
        challenge = yield request_challenge
        login(challenge)

      end
      
      def request_challenge
        request_handler.call({ 'mode' => 'getchallenge' })
      end

      def login(challenge)
        user = config['user_key']
        hash = config['user_pass_hash']
        payload = {
          'mode' => 'login',
          'user' => user,
          'auth_method' => 'challenge',
          'auth_challenge' => challenge['challenge'],
          'auth_response' => Digest::MD5.hexdigest(challenge['challenge'] + hash)
        }
        request_handler
          .call(payload)
          .bind { |rz| Sync::Blog::PostConvert.call(data: rz, rules: POST_PROCESS_RULES) }
      end

    end
  end
end
