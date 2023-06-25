Sequel.migration do
  change do
    create_table(:user_sessions) do
      primary_key :id, type: :Bignum

      column :uuid, 'uuid', null: false
      column :created_at, 'timestamp', null: false
      column :updated_at, 'timestamp', null: false

      foreign_key :user_id, :users, type: 'bigint', null: false

      index :uuid
      index :user_id
    end
  end
end
