Sequel.migration do
  change do
    create_table(:ads) do
      primary_key :id, type: 'bigint'

      column :title, 'varchar', null: false
      column :description, 'text', null: false
      column :city, 'varchar', null: false
      column :lat, 'double precision'
      column :lon, 'double precision'
      column :created_at, 'timestamp'
      column :updated_at, 'timestamp'

      column :user_id, 'bigint', null: false
      index :user_id
    end
  end
end
