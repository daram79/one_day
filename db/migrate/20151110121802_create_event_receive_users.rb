class CreateEventReceiveUsers < ActiveRecord::Migration
  def change
    create_table :event_receive_users do |t|
      t.integer :user_id
      t.string  :user_email
      t.integer  :event_site_id
      t.boolean :is_receive, default: true
      t.timestamps
    end
    add_index :event_receive_users, [:event_site_id, :is_receive]
  end
end
