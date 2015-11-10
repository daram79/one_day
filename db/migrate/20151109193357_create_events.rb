class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :event_id
      t.string :event_name
      t.string :event_url
      t.integer  :event_site_id
      t.timestamps
    end
    add_index :events, [:event_id, :event_site_id]
  end
end
