class CreateConvenienceItems < ActiveRecord::Migration
  def change
    create_table :convenience_items do |t|
      t.integer :convenience_item_kind_id #과자, 과일, 음료...
      t.string :item_type  #1+1 2+1 3+1 증정품
      t.string :conveni_name
      t.string :name
      t.string :image_url
      t.integer :price
      t.string :gift_name
      t.string :gift_image_url
      t.integer :gift_price
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :is_show
      t.timestamps
    end
    add_index :convenience_items, [:conveni_name, :item_type]
    add_index :convenience_items, :name
    add_index :convenience_items, :item_type
  end
end
