class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :feed_id
      t.integer :user_id
      t.string :nick
      t.text  :content
      t.string :ip
      t.timestamps
    end
    add_index :comments, :feed_id
  end
end
