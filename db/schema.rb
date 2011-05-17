# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 6) do

  create_table "cdr", :force => true do |t|
    t.datetime "calldate",                  :default => '2011-03-01 04:33:47', :null => false
    t.string   "clid",        :limit => 80, :default => "",                    :null => false
    t.string   "src",         :limit => 80, :default => "",                    :null => false
    t.string   "dst",         :limit => 80, :default => "",                    :null => false
    t.string   "dcontext",    :limit => 80, :default => "",                    :null => false
    t.string   "channel",     :limit => 80, :default => "",                    :null => false
    t.string   "dstchannel",  :limit => 80, :default => "",                    :null => false
    t.string   "lastapp",     :limit => 80, :default => "",                    :null => false
    t.string   "lastdata",    :limit => 80, :default => "",                    :null => false
    t.integer  "duration",    :limit => 8,                                     :null => false
    t.integer  "billsec",     :limit => 8,                                     :null => false
    t.string   "disposition", :limit => 45, :default => "",                    :null => false
    t.integer  "amaflags",    :limit => 8,                                     :null => false
    t.integer  "accountcode", :limit => 8,                                     :null => false
    t.string   "uniqueid",    :limit => 32, :default => "",                    :null => false
    t.string   "userfield",                 :default => "",                    :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.text     "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "postal_codes", :force => true do |t|
    t.string  "postal_code"
    t.string  "city"
    t.string  "province"
    t.string  "province_abbr"
    t.integer "area_code"
    t.string  "city_flag"
    t.integer "time_zone"
    t.string  "day_light_saving"
    t.float   "latitude"
    t.float   "longitude"
  end

  create_table "routes", :force => true do |t|
    t.integer  "territory_id", :null => false
    t.integer  "user_id",      :null => false
    t.string   "dst"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "territories", :force => true do |t|
    t.string   "sku"
    t.string   "title"
    t.string   "meta_title"
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.string   "body",             :null => false
    t.integer  "tally",            :null => false
    t.float    "latitude",         :null => false
    t.float    "longitude",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",   :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",   :null => false
    t.string   "password_salt",                       :default => "",   :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.boolean  "active",                              :default => true, :null => false
    t.string   "first_name",                                            :null => false
    t.string   "last_name",                                             :null => false
    t.string   "roles"
    t.string   "api_key"
    t.string   "api_secret"
    t.integer  "customer_id"
    t.integer  "subscription_id"
    t.string   "dst"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
