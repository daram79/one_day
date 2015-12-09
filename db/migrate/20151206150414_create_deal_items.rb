class CreateDealItems < ActiveRecord::Migration
  def change
    create_table :deal_items do |t|
      t.integer :deal_search_word_id
      t.integer :item_id, :limit => 5
      t.integer :site_id
      t.text :deal_url
      t.string :deal_image
      t.string :deal_description
      t.string :deal_title
      t.integer :deal_price
      
      t.integer  :deal_original_price
      t.integer  :discount
      t.string  :special_price
      t.date    :deal_start
      
      
      t.integer :deal_count
      t.integer :like_count
      t.string :card_interest_description
      t.string :deliver_charge_description
      t.boolean :is_closed, default: false
      t.timestamps
    end
    add_index :deal_items, [:site_id, :item_id]
    add_index :deal_items, :site_id
    add_index :deal_items, :deal_description
    add_index :deal_items, :deal_title
    add_index :deal_items, :is_closed
    
  end
end
