class CreateEventUserRegistrations < ActiveRecord::Migration
  def change
    create_table :event_user_registrations do |t|
      t.integer :event_user_id
      t.text    :registration_id, :null => false
      t.timestamps
    end
    add_index :event_user_registrations, :event_user_id
  end
end
