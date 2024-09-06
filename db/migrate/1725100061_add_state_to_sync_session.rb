Sequel.migration do
  change do
    alter_table(:sync_session) do
      add_column :state, Integer, index: true, default: 0
    end
  end
end
