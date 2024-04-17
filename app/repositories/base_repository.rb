# frozen_string_literal: true

require 'hunt_flow'

module Huntflow
  class BaseRepository
    # rubocop:disable Lint/MissingSuper
    def self.inherited(klass)
      klass.include Dry::Monads[:do, :maybe, :result, :try]
    end
    # rubocop:enable Lint/MissingSuper

    private

    def connect_to_huntflow
      ::Huntflow::ConnectToHuntflow.call
    end

    def result_of(response)
      # response isn't a monad, so we should wrap it
      return Success(response) if response.success?

      Failure(HuntflowResponseFailure.new(response.message))
    end

    class HuntflowResponseFailure < StandardError; end
  end
end
