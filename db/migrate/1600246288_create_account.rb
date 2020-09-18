Sequel.migration do
  change do
    create_table(:account) do
      primary_key :id
      String :login
      String :encrypted_password
      String :token
      String :salt
      foreign_key :user_id
    end
  end
end
