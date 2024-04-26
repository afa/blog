module Sync
  module Blog
    class PrepareChallenge < BaseInteractor
      option :source
      option :config, default: -> { App.config.dig('sync', 'blog') }
      option :request_handler, default: -> { Sync::Blog::Request }

      def call
        Try {
          challenge = yield request_challenge
          user = source.login_options['user_key']
          hash = source.login_options['user_pass_hash']
          {
            'user' => user,
            'auth_method' => 'challenge',
            'auth_challenge' => challenge['challenge'],
            'auth_response' => Digest::MD5.hexdigest(challenge['challenge'] + hash)
          }
        }
          .to_result
      end

      def request_challenge
        request_handler.call({ 'mode' => 'getchallenge' }, source:)
      end
    end
  end
end
