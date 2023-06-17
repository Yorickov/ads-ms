Sequel.migration do
  change do
    create_table(:ads) do
      primary_key :id, type: :Bignum

      column :title, 'character varying', null: false
      column :description, 'text', null: false
      column :city, 'character varying', null: false
      column :lat, 'double precision'
      column :lon, 'double precision'
      column :created_at, 'timestamp', null: false
      column :updated_at, 'timestamp', null: false

      column :user_id, :Bignum, null: false
      index :user_id
    end
  end
end
