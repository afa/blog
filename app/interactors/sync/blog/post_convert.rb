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
          separated = data
            .keys
            .each_with_object({}) { |key, obj|
              obj[key] = match?(key)
            }
            .each_with_object({tail: {}, arrays: {}}) {|(k, v), obj|
              if v
                # apply rule, format name - index - name - val or name - index - val
                # original key => rexp
                extract_matched(k, v).each { |aname, indexed|
                  obj[:arrays][aname] ||= {}
                  indexed.each { |aidx, astruct|
                    if astruct.is_a?(Hash)
                      obj[:arrays][aname][aidx] ||= {}
                      astruct.keys.each { |skey|
                        obj[:arrays][aname][aidx][skey] = astruct[skey]
                      }
                    else
                      obj[:arrays][aname][aidx] = astruct
                    end
                  }
                }
              else
                obj[:tail][k] = data[k]
              end
            }
            .tap { |obj|
              obj[:converted] = obj[:arrays].each_with_object({}) { |(name, hsh), rzlt|
                rzlt[name] = hsh.to_a.sort_by { |arr| sort_key_convertor.call(arr.first) }.map(&:last)
              }
            }
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
        if m
          key = m[1]
          {
            rindex[rexp] => {
              key => (rules[rindex[rexp]].is_a?(Hash) ? { rules[rindex[rexp]][rexp] => data[datakey] } : data[datakey])
            }
          }
        end
      end

      def rindex
        @rindex ||= rules
          .flat_map { |k, v| v.is_a?(Hash) ? v.keys.map { |i| [i, k] } : [[v, k]] }
          .to_h
      end
    end
  end
end
