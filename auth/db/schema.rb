Sequel.migration do
  change do
    create_table(:schema_info) do
      column :version, "integer", :default=>0, :null=>false
    end
    
    create_table(:schema_seeds) do
      column :filename, "text", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:users) do
      primary_key :id, :type=>:Bignum
      column :name, "character varying", :null=>false
      column :email, "text", :null=>false
      column :password_digest, "character varying", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:email], :unique=>true
    end
    
    create_table(:user_sessions) do
      primary_key :id, :type=>:Bignum
      column :uuid, "uuid", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      foreign_key :user_id, :users, :type=>"bigint", :null=>false, :key=>[:id]
      
      index [:user_id]
      index [:uuid]
    end
  end
end
