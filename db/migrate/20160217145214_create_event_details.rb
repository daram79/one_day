class CreateEventDetails < ActiveRecord::Migration
  def change
    create_table :event_details do |t|
      t.integer :event_id
      t.string  :title
      t.text    :content_1
      t.text    :content_2
      t.text    :content_3
      t.text    :content_4
      t.text    :content_5
      t.text    :content_6
      t.text    :content_7
      t.text    :content_8
      t.text    :content_9
      t.text    :content_10
      t.string  :next_url
      t.timestamps
    end
  end
end