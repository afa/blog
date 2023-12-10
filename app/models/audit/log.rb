class Audit::Log < Sequel::Model(:audit_log)
  KINDS = {
    sync: {}
    # login: {
    #   formatter: Audit::Formatter,
    #   avanpost_token: nil,
    #   avanpost_token_error: nil,
    #   tst1: {
    #     formatter: Audit::Formatter,
    #     tt: lambda { |who| who.to_s },
    #     dd: Audit::Formatter
    #   }
    # },
    # import: {
    #   formatter: Audit::Formatter,
    #   tst1: {
    #     formatter: Audit::Formatter,
    #     tt: lambda { |who| who.to_s },
    #     dd: Audit::Formatter
    #   }
    # }
  }

  class << self
    KINDS.each_key do |name|
      define_method name do |event, **data|
        log(name, event, **data)
      end
    end
  end

  def self.log(kind, event, **data)
    create(kind: kind, event: event, data: data, ts: Time.now.to_i)
  end

  def format(which = nil)
    matter = Audit::Formatter
    matter = KINDS.dig(kind.to_sym, event.to_sym) || matter if KINDS[kind.to_sym].is_a?(Hash)
    matter = KINDS.dig(kind.to_sym, event.to_sym, which.to_sym) || matter if which &&KINDS.dig(kind.to_sym, event.to_sym).is_a?(Hash)
    matter = matter[:formatter] if matter.is_a?(Hash) && matter[:formatter]
    matter.call(self)
  end
end
