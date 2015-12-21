class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :event_id
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
    end
    add_index :events, [:event_id, :event_site_id]
    add_index :events, [:show_flg, :update_flg]
    add_index :events, :show_flg
    add_index :events, :deal_search_word_id
    add_index :events, :item_type_code
  end
end
