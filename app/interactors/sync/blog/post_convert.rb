module Sync
  module Blog
    class PostConvert < BaseInteractor
      option :rules
      option :data

      # struct for array of sntuct:
      # array_name => { rexp => attr_name }
      # struct for array:
      # array_name => rexp
      #
      # reverse index: rexp => array_name
      def call
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

      end

      # private

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

      def extract_array(hash, rexp, name, &cvt)
        Try {
          rez = hash.each_with_object({ tail: {}, array: {} }) do |(k, v), obj|
            m = rexp.match(k)
            if m
              key = cvt.call(m[1])
              obj[:array][key] = v
            else
              obj[:tail][k] = v
            end
          end
          rez[:tail].merge(name => rez[:array].keys.sort.map { |k| rez[:array][k] })
        }
          .to_result
      end

      def rindex
        @rindex ||= rules
          .flat_map { |k, v| v.is_a?(Hash) ? v.keys.map { |i| [i, k] } : [[v, k]] }
          .to_h
      end
    end
  end
end
