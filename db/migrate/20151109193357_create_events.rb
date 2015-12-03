class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
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
      t.timestamps
    end
    add_index :events, [:event_id, :event_site_id]
    add_index :events, [:show_flg, :update_flg]
    add_index :events, :show_flg
  end
end
