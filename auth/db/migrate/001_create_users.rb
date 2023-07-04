Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id, type: :Bignum

      column :name, 'character varying', null: false
      column :email, 'text', null: false
      column :password_digest, 'character varying', null: false
      column :created_at, 'timestamp', null: false
      column :updated_at, 'timestamp', null: false

      index :email, unique: true
    end
  end
end
