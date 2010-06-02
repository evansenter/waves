# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100602171010) do

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.string   "mbid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "queried",    :default => false
  end

  create_table "similarities", :force => true do |t|
    t.integer  "artist_id"
    t.integer  "similar_artist_id"
    t.decimal  "score",             :precision => 10, :scale => 9
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "similarities", ["artist_id"], :name => "index_similarities_on_artist_id"
  add_index "similarities", ["similar_artist_id"], :name => "index_similarities_on_similar_artist_id"

end
