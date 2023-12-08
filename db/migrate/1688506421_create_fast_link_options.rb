Sequel.migration do
  change do
    create_table(:fast_link_option) do
      primary_key :id
      String :type
      column :data, :jsonb, null: false, default: '{}'
      String :appendable_extension
      String :mime_type
    end

    alter_table(:fast_link) do
      add_foreign_key :option_id, :fast_link_option
    end
  end
end

