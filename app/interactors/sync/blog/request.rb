module Sync
  module Blog
    class Request < BaseInteractor
      param :data
      option :handler, default: -> { HTTP.new }

      def call
      end
    end
  end
end

