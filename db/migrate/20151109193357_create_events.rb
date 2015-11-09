class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :event_id
      t.string :event_name
      t.string :event_url
      t.string  :site_name
      t.timestamps
    end
    add_index :events, [:event_id, :site_name]
  end
end
