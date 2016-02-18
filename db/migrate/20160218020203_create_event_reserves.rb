class CreateEventReserves < ActiveRecord::Migration
  def change
    create_table :event_reserves do |t|
      t.string :event_id
      t.integer :event_site_id
      t.string  :event_name
      t.string  :event_url
      t.string  :image_url, default: ""
      t.string  :discount, default: ""
      t.integer  :price
      t.string  :original_price, default: ""
      t.boolean :show_flg, default: false
      t.boolean :push_flg, default: false
      t.boolean :update_flg, default: false
      t.integer :deal_search_word_id
      t.integer :item_type_code
      t.datetime :add_time
      t.boolean :add_flg, default: false
      t.datetime :close_time
      t.boolean :close_flg, default: false
      t.boolean :push, default: false
      t.timestamps
    end
    add_index :event_reserves, :add_flg
    add_index :event_reserves, :close_flg
  end
end
