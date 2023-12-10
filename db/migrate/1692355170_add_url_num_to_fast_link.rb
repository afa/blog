Sequel.migration do
  change do
    alter_table(:fast_link) do
      add_column :url_num, Integer
      add_index :url_num
    end
  end
end
