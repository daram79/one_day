class CreateFeedPhotos < ActiveRecord::Migration
  def change
    create_table :feed_photos do |t|
      t.integer :feed_id
      t.string  :image
      t.timestamps
    end
  end
end
