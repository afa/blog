Sequel.migration do
  change do
    create_table(:sync_source) do
      primary_key :id
      String :name
      String :kind
      
      String :api_url
      column :login_options, :jsonb, null: false, default: '{}'
      index [:kind, :name], unique: true
    end
  end
end
