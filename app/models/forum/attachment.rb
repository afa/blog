module Forum
  class Attachment < Sequel::Model(App.ext_db&.fetch(:moz)[:forum_attachment])
    many_to_one :user, key: :userid, class: Forum::User
  end
end


# attachmentid | userid | dateline | thumbnail_dateline | filename | filedata | visible | counter | filesize | postid | filehash | posthash | thumbnail | thumbnail_filesize | extension
