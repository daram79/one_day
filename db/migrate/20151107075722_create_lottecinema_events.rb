class CreateLottecinemaEvents < ActiveRecord::Migration
  def change
    create_table :lottecinema_events do |t|
      t.integer :event_id
      t.string :event_name
      t.string :event_url
      t.timestamps
    end
    add_index :lottecinema_events, :event_id
  end
end
