Sequel.migration do
  change do
    alter_table(:sync_source) do
      add_column :strategy, String
      add_column :protocol, String
    end
  end
end
