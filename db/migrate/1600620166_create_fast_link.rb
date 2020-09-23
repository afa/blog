Sequel.migration do
  change do
    create_table(:fast_link) do
      primary_key :id
      String :name, null: true
      String :url, null: false
      foreign_key :author_id, :user
      String :url_key, null: false
      String :comment, null: true
      index [:url_key], unique: true
    end
  end
end
