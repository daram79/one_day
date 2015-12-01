class CreateEventUserPushes < ActiveRecord::Migration
  def change
    create_table :event_user_pushes do |t|
      t.integer :event_id
      t.integer :event_user_id
      t.boolean :send_flg, default: false
      t.timestamps
    end
    add_index :event_user_pushes, :send_flg
  end
end
