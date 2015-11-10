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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151110122309) do

  create_table "alrams", force: true do |t|
    t.integer  "user_id"
    t.integer  "alram_id"
    t.string   "alram_type"
    t.integer  "send_user_id"
    t.boolean  "send_flg",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alrams", ["send_flg"], name: "index_alrams_on_send_flg", using: :btree
  add_index "alrams", ["user_id"], name: "index_alrams_on_user_id", using: :btree

  create_table "cgv_events", force: true do |t|
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cgv_events", ["event_id"], name: "index_cgv_events_on_event_id", using: :btree

  create_table "clien_coupon_events", force: true do |t|
    t.integer  "event_id"
    t.string   "event_name"
    t.string   "event_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clien_coupon_events", ["event_id"], name: "index_clien_coupon_events_on_event_id", using: :btree

  create_table "clien_frugal_events", force: true do |t|
    t.integer  "event_id"
    t.string   "event_name"
    t.string   "event_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clien_frugal_events", ["event_id"], name: "index_clien_frugal_events_on_event_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "feed_id"
    t.integer  "user_id"
    t.string   "nick"
    t.text     "content"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["feed_id"], name: "index_comments_on_feed_id", using: :btree

  create_table "event_mailing_lists", force: true do |t|
    t.string   "email"
    t.boolean  "send_flg",   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_mailing_lists", ["send_flg"], name: "index_event_mailing_lists_on_send_flg", using: :btree

  create_table "event_receive_users", force: true do |t|
    t.integer  "user_id"
    t.string   "user_email"
    t.integer  "event_site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_receive_users", ["event_site_id"], name: "index_event_receive_users_on_event_site_id", using: :btree

  create_table "event_sites", force: true do |t|
    t.string   "site_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.integer  "event_id"
    t.string   "event_name"
    t.string   "event_url"
    t.integer  "event_site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["event_id", "event_site_id"], name: "index_events_on_event_id_and_event_site_id", using: :btree

  create_table "feed_photos", force: true do |t|
    t.integer  "feed_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_tags", force: true do |t|
    t.integer  "feed_id"
    t.string   "tag_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_tags", ["tag_name"], name: "index_feed_tags_on_tag_name", using: :btree

  create_table "feeds", force: true do |t|
    t.integer  "user_id"
    t.string   "nick"
    t.text     "content"
    t.text     "html_content"
    t.integer  "like_count",    default: 0
    t.integer  "comment_count", default: 0
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "likes", force: true do |t|
    t.integer  "feed_id"
    t.integer  "user_id"
    t.string   "like_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["feed_id"], name: "index_likes_on_feed_id", using: :btree

  create_table "lottecinema_events", force: true do |t|
    t.integer  "event_id"
    t.string   "event_name"
    t.string   "event_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lottecinema_events", ["event_id"], name: "index_lottecinema_events_on_event_id", using: :btree

  create_table "notices", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_first_nicks", force: true do |t|
    t.string   "nick"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_second_nicks", force: true do |t|
    t.string   "nick"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.text     "registration_id"
    t.boolean  "alram_on",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
