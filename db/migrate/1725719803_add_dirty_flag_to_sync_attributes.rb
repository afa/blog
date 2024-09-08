Sequel.migration do
  change do
    add_column :sync_attribute, :dirty, TrueClass, default: false
  end
end
