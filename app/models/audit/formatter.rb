class Audit::Formatter
  def self.call(log)
    new.call(log)
  end

  def call(log)
    "#{log.kind}##{log.event}@#{Time.at(log.ts)}: #{log.data.keys.sort.map { |k| "#{k}->#{log.data[k]}" }.join(', ')}"
  end
end
