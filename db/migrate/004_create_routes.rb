class CreateRoutes < ActiveRecord::Migration
  def self.up
    create_table :routes do |t|
      t.references :territory,  :null => false
      t.references :user,       :null => false

      t.string     :dst

      t.timestamps
    end
  end

  def self.down
    drop_table :routes
  end
end