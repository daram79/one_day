class CreateEventBackUps < ActiveRecord::Migration
  def change
    create_table :event_back_ups do |t|
      t.integer :event_id, :limit => 5
      t.integer :event_site_id
      t.string  :event_name
      t.string  :event_url
      t.string  :image_url, default: ""
      t.string  :discount, default: ""
      t.string  :price, default: ""
      t.string  :original_price, default: ""
      t.boolean :show_flg, default: false
      t.boolean :push_flg, default: false
      t.boolean :update_flg, default: false
      t.integer :deal_search_word_id
      t.integer :item_type_code
      t.timestamps
      t.timestamps
    end
  end
end
