module Sync
  module Blog
    class PostConvert < BaseInteractor
      option :rules
      option :data
      option :sort_key_convertor, default: -> { ->(item) { item.to_i } }

      # struct for array of sntuct:
      # array_name => { rexp => attr_name }
      # struct for array:
      # array_name => rexp
      #
      # reverse index: rexp => array_name
      def call
        Try {
          data
            .keys
            .each_with_object({}) { |key, obj|
              obj[key] = match?(key)
            }
            .each_with_object({ tail: {}, arrays: {} }) { |(k, v), obj|
              if v
                # apply rule, format name - index - name - val or name - index - val
                # original key => rexp
                matches = extract_matched(k, v)
                build_arrays(matches, obj[:arrays])
              else
                obj[:tail][k] = data[k]
              end
            }
            .tap { |obj| obj[:converted] = hashes_to_arrays(obj[:arrays]) }
            .then { |obj| obj[:tail].merge(obj[:converted]) }
        }
          .to_result
      end

      private

      def match?(str)
        rindex.keys.find { |k| k =~ str }
      end

      def extract_matched(datakey, rexp)
        m = rexp.match(datakey)
        return unless m

        {
          rindex[rexp] => {
            m[1] => (rules[rindex[rexp]].is_a?(Hash) ? { rules[rindex[rexp]][rexp] => data[datakey] } : data[datakey])
          }
        }
      end

      def build_arrays(matches, place)
        matches.each { |aname, indexed|
          place[aname] ||= {}
          indexed.each { |aidx, astruct|
            if astruct.is_a?(Hash)
              place[aname][aidx] ||= {}
              astruct.each_key { |skey|
                place[aname][aidx][skey] = astruct[skey]
              }
            else
              place[aname][aidx] = astruct
            end
          }
        }
      end

      def hashes_to_arrays(obj)
        obj.transform_values { |hsh|
          hsh.to_a.sort_by { |arr| sort_key_convertor.call(arr.first) }.map(&:last)
        }
      end

      def rindex
        @rindex ||= rules
                    .flat_map { |k, v| v.is_a?(Hash) ? v.keys.map { |i| [i, k] } : [[v, k]] }
                    .to_h
      end
    end
  end
end
