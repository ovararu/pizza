

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.confirmable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.token_authenticatable

      # banned users, should just delete....
      t.boolean :active,                :null => false, :default => true

      # names!
      t.string :first_name,             :null => false
      t.string :last_name,              :null => false

      # admin, nil
      t.string    :roles
      
      # TBC
      t.string    :api_key     #,       :null => false
      t.string    :api_secret  #,       :null => false

      # chargify
      t.integer  :customer_id
      t.integer  :subscription_id

      # default route
      t.string     :dst

      t.timestamps
    end
    
    
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
  end
end