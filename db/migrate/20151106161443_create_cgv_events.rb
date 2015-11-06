class CreateCgvEvents < ActiveRecord::Migration
  def change
    create_table :cgv_events do |t|
      t.integer :event_id
      t.boolean :is_send, default: false
      t.timestamps
    end
    add_index :cgv_events, :event_id
    add_index :cgv_events, :is_send
  end
end
