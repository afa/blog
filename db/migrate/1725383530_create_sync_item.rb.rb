Sequel.migration do
  change do
    create_table(:sync_item) do
      primary_key :id
      String :key
      foreign_key :session_id, :sync_session, null: false, on_delete: :cascade
      foreign_key :structure_id, :sync_structure, on_delete: :cascade, null: false
      String :external_key, null: false
      String :internal_key, null: true
    end
  end
end
