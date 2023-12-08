Sequel.migration do
  change do
    create_schema(:import, if_not_exists: true)
    create_table(Sequel::LiteralString.new('import.livejournal_post')) do
      primary_key :id
    end
  end
end
