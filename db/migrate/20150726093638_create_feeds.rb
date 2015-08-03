class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.integer :user_id
      t.string  :nick
      t.text  :content
      t.text  :html_content
      t.integer :like_count, default: 0
      t.integer :comment_count, default: 0
      t.string :ip
      t.timestamps
    end
  end
end
