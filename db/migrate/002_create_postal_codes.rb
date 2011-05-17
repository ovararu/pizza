class CreatePostalCodes < ActiveRecord::Migration
  def self.up
    create_table :postal_codes do |t|
      
      t.string  :postal_code
      t.string  :city
      t.string  :province
      t.string  :province_abbr
      t.integer :area_code
      
      t.string  :city_flag
      
      t.integer :time_zone
      t.string :day_light_saving # replace "Y" or "N", for now string, adjust generate rb...
      
      t.float :latitude
      t.float :longitude
      
      # t.timestamps
    end
  end

  def self.down
    drop_table :postal_codes
  end
end
