require 'nokogiri'
require 'ostruct'
class BlogpostsImport < Thor
  desc 'files PATH', 'load import files from lj_backup to data dir'
  def files(path)
    puts 'files'
  end

  desc 'parse_posts PATH', 'parse li_import\'ed files'
  def parse_posts(path)
    ["eventtime", "ditemid", "event_timestamp", "reply_count", "logtime", "props", "can_comment", "anum", "subject"]
    maps = %w[reply_count itemid ditemid anum eventtime logtime].map { |key| [key, key] }.to_h.merge(
      'body' => 'event', 'title' => 'subject', 'origin_url' => 'url', 'commentable' => 'can_comment',
      'timestamp' => 'event_timestamp'
    )
    # xslt = Nokogiri::XSLT(File.read(File.join(%w[. config xslt lj_import_post.xslt])))
    Dir[File.join(path, 'L-*')].each do |name|
      xml = Nokogiri::XML(File.read(name))

      data = Import::Livejournal::Post.new(
        maps.each_with_object({}) { |(k, v), obj| obj[k.to_sym] = xml.xpath("/event/#{v}").text }
      )
      p data
      p xml.xpath('/event/props')
      p xml.xpath('/event').children.map(&:name).reject { |n| (maps.values + ['text']).include?(n) }
      break
      # prepared = xslt.transform(xml)
      # p prepared, prepared.each { |x| p x }
    end
  end

  desc 'parse_lj FILE', 'parse prepared xml import file'
  def parse_lj(file)
    xslt = Nokogiri::XSLT(File.read(File.join(%w[. config xslt lj_import.xslt])))
    doc = Nokogiri::XML(File.read(file))
    p xslt.transform(doc).to_h
    # p xslt.apply_to(doc)
  end
end
