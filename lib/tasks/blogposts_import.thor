require 'nokogiri'
require 'ostruct'
class BlogpostsImport < Thor
  desc 'files PATH', 'load import files from lj_backup to data dir'
  def files(path)
    puts 'files'
  end

  desc 'parse_posts PATH', 'parse li_import\'ed files'
  def parse_posts(path)
    maps = %w[reply_count itemid ditemid anum eventtime security allowmask logtime]
           .map { |key| [key, key] }
           .to_h
           .merge(
             'body' => 'event', 'title' => 'subject', 'origin_url' => 'url', 'commentable' => 'can_comment',
             'timestamp' => 'event_timestamp'
           )
    mprops = %w[
      repost_author repost_subject repost_url repost current_moodid personifi_lang opt_preformatted give_features
      opt_nocomments personifi_tags taglist current_mood current_music current_location copyright
      adult_content
    ]
             .map { |key| [key, key] }
             .to_h
             .merge({})
    # xslt = Nokogiri::XSLT(File.read(File.join(%w[. config xslt lj_import_post.xslt])))
    importable = Dir[File.join(path, 'L-*')].each_with_object([]) do |name, list|
      xml = Nokogiri::XML(File.read(name))

      data = Import::Livejournal::Post.new(
        maps
        .each_with_object({}) { |(k, v), obj| obj[k.to_sym] = xml.xpath("/event/#{v}").text }
        .merge(
          props: mprops.each_with_object({}) { |(k, v), obj| obj[k.to_sym] = xml.xpath("/event/props/#{v}").text }
        )
      )
      # p data
      plst = xml.xpath('/event/props').children.map(&:name).reject { |n| (mprops.values + %w[text]).include?(n) }
      lst = xml.xpath('/event').children.map(&:name).reject { |n| (maps.values + %w[text props]).include?(n) }
      p data.itemid, lst unless lst.empty?
      p data.itemid, plst unless plst.empty?
      list << data
      # break
      # prepared = xslt.transform(xml)
      # p prepared, prepared.each { |x| p x }
    end.sort_by(&:itemid)
    p importable.map(&:itemid)
  end

  desc 'parse_lj FILE', 'parse prepared xml import file'
  def parse_lj(file)
    xslt = Nokogiri::XSLT(File.read(File.join(%w[. config xslt lj_import.xslt])))
    doc = Nokogiri::XML(File.read(file))
    p xslt.transform(doc).to_h
    # p xslt.apply_to(doc)
  end
end
