module Sync
  module Strategy
    class RunningTotal < BaseInteractor
      # импортировать из репозитория очередную порцию данных, раскидать их в соответствии со структурой по инстансам
      # и атрибутам
      # для предыдущих версий оставляет только измененные инстансы и атрибуты (для -1 - те которые изменены в ней по
      # сравнению с текущей)

      option :session
      option :data

      def call
        Success()
      end
    end
  end
end
