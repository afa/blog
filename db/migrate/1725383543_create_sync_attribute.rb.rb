Sequel.migration do
  change do
    create_table(:sync_attribute) do
      primary_key :id
      foreign_key :item_id, :sync_item, null: false, on_delete: :cascade
      String :key
      String :value
      index [:key]
    end
  end
end
