Sequel.migration do
  change do
    alter_table(:fast_link) do
      add_column :state, Integer, default: 0, null: false
      add_index :state, unique: false, concurrently: true
    end
  end
end
