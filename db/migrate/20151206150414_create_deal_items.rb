class CreateDealItems < ActiveRecord::Migration
  def change
    create_table :deal_items do |t|
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
      t.timestamps
    end
    add_index :deal_items, [:site_id, :item_id]
    add_index :deal_items, :site_id
    add_index :deal_items, :deal_description
    add_index :deal_items, :deal_title
  end
end
