class CreateCgvEvents < ActiveRecord::Migration
  def change
    create_table :cgv_events do |t|
      t.integer :event_id
      t.timestamps
    end
    add_index :cgv_events, :event_id
  end
end
