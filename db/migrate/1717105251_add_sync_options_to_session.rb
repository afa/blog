Sequel.migration do
  change do
    alter_table(:sync_session) do
      add_column :sync_options, :jsonb, null: false, default: '{}'
    end
  end
end
