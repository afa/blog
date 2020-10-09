Sequel.migration do
  change do
    create_table(:blog_post) do
      primary_key :id
      String :title
      String :body, text: true
      DateTime :created_at
      DateTime :published_at, null: true
      DateTime :updated_at
    end
  end
end
