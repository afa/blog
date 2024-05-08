require 'net/http'
module Sync
  module Blog
    class Request < BaseInteractor
      param :data
      option :handler, default: -> { Net::HTTP }
      option :source

      def call
        Try {
          url = URI(source.api_url)
          payload = yield prepare_data
          handler.post(url, payload, 'Content-Type' => 'application/x-www-form-urlencoded')
        }
          .bind { |response|
            return Failure(response) unless response.is_a?(Net::HTTPSuccess)

            parse_response(response.body)
          }
          .bind { |reply|
            return Failure(reply) unless reply['success'] == 'OK'

            Success(reply)
          }
      end

      private

      def prepare_data
        Try {
          URI.encode_www_form(data)
        }
          .to_result
      end

      def parse_response(response)
        Try {
          response.split("\n").each_slice(2).with_object({}) { |(key, val), obj| obj[key] = val }
        }
          .to_result
      end
    end
  end
end
