# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120905005130) do

  create_table "arrivals", :force => true do |t|
    t.string   "traveler_name"
    t.datetime "time"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "car_id"
    t.string   "airline"
    t.string   "flight_number"
  end

  create_table "car_seats", :force => true do |t|
    t.integer  "arrival_id"
    t.integer  "car_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "departure_id"
  end

  create_table "cars", :force => true do |t|
    t.string   "name"
    t.integer  "num_seats"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "shuttle",    :default => false
  end

  create_table "departures", :force => true do |t|
    t.string   "traveler_name"
    t.datetime "time"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "car_id"
    t.string   "airline"
    t.string   "flight_number"
  end

end
