module Forum
  class User < Sequel::Model(App.ext_db&.fetch(:moz)[:forum_user])
    one_to_many :attachments, key: :userid, class: Forum::Attachment
  end
end

