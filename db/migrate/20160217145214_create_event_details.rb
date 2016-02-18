class CreateEventDetails < ActiveRecord::Migration
  def change
    create_table :event_details do |t|
      t.integer :event_id
      t.string  :title
      t.text    :content
      t.string  :next_url
      t.timestamps
    end
  end
end
