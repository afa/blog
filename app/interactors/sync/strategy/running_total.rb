module Sync
  module Strategy
    class RunningTotal < BaseInteractor
      # импортировать из репозитория очередную порцию данных, раскидать их в соответствии со структурой по инстансам
      # и атрибутам
      # для предыдущих версий оставляет только измененные инстансы и атрибуты (для -1 - те которые изменены в ней по
      # сравнению с текущей)
      # основные отличия объектов от ассоциаций -- объекты белонгс ту, линк хранится в основном итеме, название
      #  переменной берется из хэша объектс конфига

      option :session
      option :data

      def call
        config = yield configuration
        extracted = yield parse(config)
        pp extracted
        saved = yield save_items(session.source.structure, extracted)
        yield save_attributes(extracted, config).alt_map { rollback(saved) }
        session.update_fields(state: :parsed)
        yield build_diff
        session.update_fields(state: :processed)
        apply_diff
      end

      private

      def configuration
        Maybe(session)
          .maybe { |s| s.source }
          .maybe { |s| s.structure }
          .maybe { |s| s.structure_rules }
          .to_result
      end

      # TODO: refactor methods
      def parse(config)
        # scan each hash^ key is item type, val is array with hashes each with key-attr, store each item with tablename
        # store unknown attributes
        Try {
          data.each do |key, tab|
            cfg = config[key]
            pp cfg
            tab.each do |val, item|
              item = { id: items_id, kind: key, attributes: {}, dirty: {} }
              val.each { |k, v| item[:attributes][k] = v if cfg['attributes'].key?(k) }
              (val.keys - cfg['attributes'].keys - cfg['objects'].keys - cfg['associations']).each do |k|
                item[:dirty].merge!(k => val[k])
              end
              items << item
              val.each { |k, v| extract_object(config, k, v, item[:id]) if cfg['objects'].key?(k) }
              val.each { |k, v| extract_associations(config, k, v, item[:id]) if cfg['associations'].include?(k) }
            end
          end
          items
        }
          .to_result
      end

      # переписать под сохранение линка (связи) в основной объект, в переменную из хэша объектс
      def extract_object(config, key, val, local_id)
        cfg = config[key]
        item = { id: items_id, kind: key, attributes: {}, dirty: {}, linked_to: local_id, linked: items[local_id][:kind] }
        val.each { |k, v| item[:attributes][k] = v if cfg['attributes'].key?(k) }
        (val.keys - cfg['attributes'].keys - cfg['objects'].keys - cfg['associations']).each do |k|
          item[:dirty].merge!(k => val[k])
        end
        items << item
        val.each { |k, v| extract_object(config, k, v, item[:id]) if cfg['objects'].key?(k) }
        val.each { |k, v| extract_associations(config, k, v, item[:id]) if cfg['associations'].include?(k) }
      end

      def extract_associations(config, key, val, local_id)
        cfg = config[key]
        val.each do |value|
          item = { id: items_id, kind: key, attributes: {}, dirty: {}, linked_to: local_id, linked: items[local_id][:kind] }
          value.each { |k, v| item[:attributes][k] = v if cfg['attributes'].key?(k) }
          (value.keys - cfg['attributes'].keys - cfg['objects'].keys - cfg['associations']).each do |k|
            item[:dirty].merge!(k => value[k])
          end
          items << item
          value.each { |k, v| extract_object(config, k, v, item[:id]) if cfg['objects'].key?(k) }
          value.each { |k, v| extract_associations(config, k, v, item[:id]) if cfg['associations'].include?(k) }
        end
      end

      def save_items(structure, extracted)
        list = extracted.each_with_object([]) do |item, arr|
          arr << Try {
            ext_key = item[:attributes][structure.structure_rules[item[:kind]]['key']]
            Sync::Item.create(
              key: item[:kind],
              session_id: session.pk,
              structure_id: structure.pk,
              external_key: ext_key
            )
          }
            .to_result
        end
        List(list).typed(Try).traverse
      end

      # after save session parsed
      def save_attributes(extracted, config)

      end

      def rollback(items)

      end
      def build_diff

      end

      def apply_diff

      end

      def items
        @items ||= []
      end

      def items_id
        items.size
      end
    end
  end
end
