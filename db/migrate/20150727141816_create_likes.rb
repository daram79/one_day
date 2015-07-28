class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :feed_id
      t.integer :user_id
      t.string  :like_type
      t.timestamps
    end
    add_index :likes, :feed_id
  end
end
