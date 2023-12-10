Sequel.migration do
  change do
    create_table :audit_log do
      String :kind, null: false
      BigDecimal :ts, null: false
      String :event, null: false
      column :data, :jsonb, null: false, default: '{}'
      index [:kind]
      index [:event]
      index [:ts]
    end
  end
end
