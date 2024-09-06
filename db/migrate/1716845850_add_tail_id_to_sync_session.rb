Sequel.migration do
  change do
    alter_table(:sync_session) do
      add_foreign_key :tail_id, :sync_session, null: true, on_delete: :set_null
    end
  end
end
