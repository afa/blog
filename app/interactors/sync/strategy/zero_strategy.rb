module Sync
  module Strategy
    class ZeroStrategy < BaseInteractor
      option :session
      option :data

      def call
        Success()
      end
    end
  end
end
