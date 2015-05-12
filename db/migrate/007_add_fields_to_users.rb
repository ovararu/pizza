class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :business_name, :string
    add_column :users, :business_address, :string
    add_column :users, :business_city, :string
    add_column :users, :business_province, :string
    add_column :users, :business_postal_code, :string
  end

  def self.down
    remove_column :users, :business_name
    remove_column :users, :business_address
    remove_column :users, :business_city
    remove_column :users, :business_province
    remove_column :users, :business_postal_code
  end
end
