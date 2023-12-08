Sequel.migration do
  change do
    create_table(:user) do
      primary_key :id
      String :first_name
      String :last_name
    end
  end
end
