class CreateEventAddWaitUrls < ActiveRecord::Migration
  def change
    create_table :event_add_wait_urls do |t|
      t.string :url
      t.boolean :is_add, default: false
      t.timestamps
    end
    add_index :event_add_wait_urls, :is_add
  end
end
