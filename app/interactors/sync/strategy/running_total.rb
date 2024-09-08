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
        saved = yield save_items(session.source.structure, extracted)
        yield save_attributes(extracted).alt_map { rollback }
        session.update(state: :parsed)
        yield build_diff
        session.update(state: :processed)
        apply_diff
      end

      private

      def configuration
        Maybe(session)
          .maybe(&:source)
          .maybe(&:structure)
          .maybe(&:structure_rules)
          .to_result
      end

      # TODO: refactor methods
      def parse(config)
        # scan each hash^ key is item type, val is array with hashes each with key-attr, store each item with tablename
        # store unknown attributes
        Try {
          data.each do |key, tab|
            cfg = config[key]
            tab.each do |val|
              item = { id: items_id, kind: key, attributes: {}, dirty: {} }
              val.each { |k, v| item[:attributes][k] = v if cfg['attributes'].key?(k) }
              (val.keys - cfg['attributes'].keys - cfg['objects'].keys - cfg['associations']).each do |k|
                item[:dirty].merge!(k => val[k])
              end
              items << item
              val.each { |k, v|
                extract_object(config, k, v, item[:id]) if cfg['objects'].key?(k)
                extract_associations(config, k, v, item[:id]) if cfg['associations'].include?(k)
              }
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
        val.each { |k, v|
          extract_object(config, k, v, item[:id]) if cfg['objects'].key?(k)
          extract_associations(config, k, v, item[:id]) if cfg['associations'].include?(k)
        }
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
          value.each { |k, v|
            extract_object(config, k, v, item[:id]) if cfg['objects'].key?(k)
            extract_associations(config, k, v, item[:id]) if cfg['associations'].include?(k)
          }
        end
      end

      def save_items(structure, extracted)
        list = extracted.each_with_object([]) do |item, arr|
          arr << Try {
            ext_key = item[:attributes][structure.structure_rules[item[:kind]]['key']]
            model = Sync::Item.create(
              key: item[:kind],
              session_id: session.pk,
              structure_id: structure.pk,
              external_key: ext_key
            )
            item[:model_id] = model.pk
          }
            .to_result
        end
        List(list).typed(Try).traverse
      end

      # after save session parsed
      def save_attributes(extracted)
        Try {
          extracted.each do |item|
            item[:attributes].each do |k, v|
              Sync::Attribute.create(key: k, value: v, dirty: false, item_id: item[:model_id])
            end
            item[:dirty].each do |k, v|
              Sync::Attribute.create(key: k, value: v, dirty: true, item_id: item[:model_id])
            end
          end
        }
          .to_result
      end

      def rollback
        Sync::Attribute.where(item_id: session.items.map(&:pk)).delete
        session.remove_all_items
      end

      def build_diff
        Success()
      end

      def apply_diff
        Success()
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
