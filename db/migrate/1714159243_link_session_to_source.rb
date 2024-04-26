Sequel.migration do
  change do
    alter_table(:sync_session) do
      add_foreign_key :source_id, :sync_source, on_delete: :restrict
    end
  end
end
