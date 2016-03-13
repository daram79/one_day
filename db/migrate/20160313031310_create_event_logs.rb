class CreateEventLogs < ActiveRecord::Migration
  def change
    create_table :event_logs do |t|
      t.integer :event_user_id
      t.string :screen_type
      t.string :action_type
      t.string :log_type
      t.timestamps
    end
  end
end
