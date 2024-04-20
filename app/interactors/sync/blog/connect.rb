require 'digest'

module Sync
  module Blog
    class Connect < BaseInteractor
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
          .bind { |rz| extract_array(rz, /^access_([1234567890]+)$/, 'access') { |s| s.to_i } }
      end

      def extract_array(hash, rexp, name, &cvt)
        Try {
          rez = hash.each_with_object({ tail: {}, array: {} }) do |(k, v), obj|
            m = rexp.match(k)
            if m
              key = cvt.call(m[1])
              obj[:array][key] = v
            else
              obj[:tail][k] = v
            end
          end
          rez[:tail].merge(name => rez[:array].keys.sort.map { |k| rez[:array][k] })
        }
          .to_result
      end
    end
  end
end
