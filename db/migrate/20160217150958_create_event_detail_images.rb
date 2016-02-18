class CreateEventDetailImages < ActiveRecord::Migration
  def change
    create_table :event_detail_images do |t|
      t.integer :event_detail_id
      t.string  :image
      t.timestamps
    end
  end
end
