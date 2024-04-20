Sequel.migration do
  up do
    create_table(:sync_session) do
      primary_key :id
      String :kind
      BigDecimal :timestamp, size: [16, 6]
      index :kind
    end
  end

  down do
    drop_table :sync_session
  end
end
