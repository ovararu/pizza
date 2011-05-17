class CreateTerritories < ActiveRecord::Migration
  def self.up
    create_table :territories do |t|
      t.string  :sku

      t.string  :title

      t.string  :meta_title        # extract from title if nil
      t.string  :meta_keywords     # extract from body if nil
      t.string  :meta_description

      t.string  :body,            :null => false

      t.integer :tally,           :null => false

      t.float   :latitude,        :null => false
      t.float   :longitude,       :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :territories
  end
end