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

ActiveRecord::Schema.define(version: 20151209092335) do

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

  create_table "deal_items", force: true do |t|
    t.integer  "deal_search_word_id"
    t.integer  "item_id",                    limit: 8
    t.integer  "site_id"
    t.text     "deal_url"
    t.string   "deal_image"
    t.string   "deal_description"
    t.string   "deal_title"
    t.integer  "deal_price"
    t.integer  "deal_original_price"
    t.integer  "discount"
    t.string   "special_price"
    t.date     "deal_start"
    t.integer  "deal_count"
    t.integer  "like_count"
    t.string   "card_interest_description"
    t.string   "deliver_charge_description"
    t.boolean  "is_closed",                            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_items", ["deal_description"], name: "index_deal_items_on_deal_description", using: :btree
  add_index "deal_items", ["deal_title"], name: "index_deal_items_on_deal_title", using: :btree
  add_index "deal_items", ["is_closed"], name: "index_deal_items_on_is_closed", using: :btree
  add_index "deal_items", ["site_id", "item_id"], name: "index_deal_items_on_site_id_and_item_id", using: :btree
  add_index "deal_items", ["site_id"], name: "index_deal_items_on_site_id", using: :btree

  create_table "deal_search_results", force: true do |t|
    t.integer  "deal_item_id"
    t.string   "deal_search_word"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_search_results", ["deal_item_id", "deal_search_word"], name: "index_deal_search_results_on_deal_item_id_and_deal_search_word", using: :btree

  create_table "deal_search_words", force: true do |t|
    t.string   "word"
    t.text     "nick"
    t.boolean  "is_on",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_search_words", ["is_on"], name: "index_deal_search_words_on_is_on", using: :btree

  create_table "event_mailing_lists", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_mailing_lists", ["email"], name: "index_event_mailing_lists_on_email", using: :btree

  create_table "event_receive_users", force: true do |t|
    t.integer  "user_id"
    t.string   "user_email"
    t.integer  "event_site_id"
    t.boolean  "is_receive",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_receive_users", ["event_site_id", "is_receive"], name: "index_event_receive_users_on_event_site_id_and_is_receive", using: :btree

  create_table "event_sites", force: true do |t|
    t.string   "site_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_user_pushes", force: true do |t|
    t.integer  "event_id"
    t.integer  "event_user_id"
    t.boolean  "send_flg",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_user_pushes", ["send_flg"], name: "index_event_user_pushes_on_send_flg", using: :btree

  create_table "event_user_registrations", force: true do |t|
    t.integer  "event_user_id"
    t.text     "registration_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_user_registrations", ["event_user_id"], name: "index_event_user_registrations_on_event_user_id", using: :btree

  create_table "events", force: true do |t|
    t.integer  "event_id",       limit: 8
    t.integer  "event_site_id"
    t.string   "event_name"
    t.string   "event_url"
    t.string   "image_url",                default: ""
    t.string   "discount",                 default: ""
    t.string   "price",                    default: ""
    t.string   "original_price",           default: ""
    t.boolean  "show_flg",                 default: false
    t.boolean  "push_flg",                 default: false
    t.boolean  "update_flg",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["event_id", "event_site_id"], name: "index_events_on_event_id_and_event_site_id", using: :btree
  add_index "events", ["show_flg", "update_flg"], name: "index_events_on_show_flg_and_update_flg", using: :btree
  add_index "events", ["show_flg"], name: "index_events_on_show_flg", using: :btree

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
