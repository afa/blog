module Sync
  module Blog
    class Connect < BaseInteractor
      option :request, default: -> { Sync::Blog::Request }
      def call
        session = yield start_session
      end
      
      def start_session
      end
    end
  end
end
