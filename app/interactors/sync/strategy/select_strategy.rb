module Sync
  module Strategy
    class SelectStrategy < BaseInteractor
      option :source

      LIST = {
        nil => Sync::Strategy::ZeroStrategy,
        'running_total' => Sync::Strategy::RunningTotal
      }.freeze
      def call
        Maybe(LIST[source&.strategy]).to_result
      end
    end
  end
end
