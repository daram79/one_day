class CreateClienFrugalEvents < ActiveRecord::Migration
  def change
    create_table :clien_frugal_events do |t|
      t.integer :event_id
      t.string :event_name
      t.string :event_url
      t.timestamps
    end
    add_index :clien_frugal_events, :event_id
  end
end
