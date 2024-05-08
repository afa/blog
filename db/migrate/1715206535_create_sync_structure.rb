Sequel.migration do
  change do
    create_table(:sync_structure) do
      primary_key :id
      foreign_key :source, :sync_source, on_delete: :restrict
      column :structure_rules, :jsonb, null: false, default: '{}'
    end
  end
end
