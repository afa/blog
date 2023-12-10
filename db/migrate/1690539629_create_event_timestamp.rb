Sequel.migration do
  transaction
  change do
    create_table(:event_timestamp) do
      primary_key :id
      BigDecimal :stamp, size: [16, 6]
      index [:stamp]
    end

    create_table(:event_timestamp_timestampable) do
      foreign_key :event_timestamp_id, :event_timestamp
      String :timestampable_type
      Integer :timestampable_id
      primary_key [:timestampable_type, :timestampable_id, :event_timestamp_id], name: 'join_table_timestampable_pk'
      index [:timestampable_type, :timestampable_id, :event_timestamp_id], name: 'join_table_timestampable_full_index'
      index [:timestampable_type, :timestampable_id], name: 'join_table_timestampable_other_index'
      index [:event_timestamp_id], name: 'join_table_timestampable_my_index'
    end
  end
end
