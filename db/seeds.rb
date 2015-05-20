# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

require 'csv'

Users.destroy_all
# 
rob = User.create(:first_name => "Robert", :last_name => "Lowe", :dst => "123-123-1234", :province => "Ontario", :email => "rob@iblargz.com", :password => "nopass", :password_confirmation => "nopass")
rob.add_role "admin"
rob.confirmed_at= Time.now
rob.confirmation_token= nil
rob.save!

#
simon = User.create(:first_name => "Simon", :last_name => "Rowland", :dst => "123-123-1234", :province => "Ontario", :email => "simon.rowland@directleap.com", :password => "nopass", :password_confirmation => "nopass")
simon.add_role "admin"
simon.confirmed_at= Time.now
simon.confirmation_token= nil
simon.save!


# 810k postal codes
puts "Executing `psql --username=postgres pizza_production -f #{RAILS_ROOT}/db/seeds/postal_codes.psql`, please wait about 10 seconds."
`psql -h localhost --username=postgres pizza_production -f #{RAILS_ROOT}/db/seeds/postal_codes.psql`



# Importing from CSV below (takes a couple of minutes)
#
#
# # import postal codes...
# PostalCode.destroy_all
# 
# count        = 1
# postal_codes = []
# 
# #import postal code world 
# puts "Loading postal codes into memory, please wait 10-30 seconds..."
# CSV.parse(File.open("#{RAILS_ROOT}/db/seeds/postal_codes.csv").read) do |row|
#   
#   # 100k is enough
#   # break if count > 2000 && Rails.env.development?
#   
#   postal_code = PostalCode.new
#   
#   postal_code.postal_code      = row[0]
#   postal_code.city             = row[1]
#   postal_code.province         = row[2]
#   postal_code.province_abbr    = row[3]
#   postal_code.area_code        = row[4]
#   postal_code.city_flag        = row[5]
#   postal_code.time_zone        = row[6]
#   postal_code.day_light_saving = row[7]
#   postal_code.latitude         = row[8]
#   postal_code.longitude        = row[9]
#   
# 
#   postal_codes << postal_code
#   
#   if count % 1000 == 0
#     puts "Inserting next bulk around of postal codes starting from #{count}"
#     
#     PostalCode.import postal_codes
#     
#     postal_codes = []
#     GC.start
#   end
#   
#   count = count + 1
# end

Territory.destroy_all

puts "Creating Postgres specific median aggregate!"
# median for centeriods
ActiveRecord::Base.connection.execute("
CREATE OR REPLACE FUNCTION array_median(double precision[])
RETURNS double precision AS
$$
SELECT CASE WHEN array_upper($1,1) = 0 THEN null 
            ELSE asorted[ceiling(array_upper(asorted,1)/2.0)]::double precision END
   FROM (SELECT ARRAY(SELECT $1[n] 
            FROM generate_series(1, array_upper($1, 1)) AS n
           WHERE $1[n] IS NOT NULL
           ORDER BY $1[n]) As asorted) As foo 
$$ LANGUAGE 'sql' IMMUTABLE;

CREATE AGGREGATE median(double precision) (
SFUNC=array_append,
STYPE=double precision[],
FINALFUNC=array_median
);
;")

puts "Importing territories from postal codes!"
# median function created in migration scripts
# migration has already created the table use INSERT INTO SELECT vs SELECT INTO (create relation in postgres)
ActiveRecord::Base.connection.execute("
INSERT INTO territories (sku, title, body, tally, latitude, longitude)
SELECT substr(postal_code, 1,3) as sku,
       substr(postal_code, 1,3) as title,
       substr(postal_code, 1,3) as body, 
       trunc(random() * 999) + 1 as tally,
       median(latitude) AS latitude, 
       median(longitude) AS longitude
  FROM postal_codes
GROUP BY sku
;")

