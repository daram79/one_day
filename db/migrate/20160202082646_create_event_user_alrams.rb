class CreateEventUserAlrams < ActiveRecord::Migration
  def change
    create_table :event_user_alrams do |t|
      t.integer :event_mailing_list_id
      t.string :menu_id
      t.timestamps
    end
    add_index :event_user_alrams, :event_mailing_list_id
    add_index :event_user_alrams, [:event_mailing_list_id, :menu_id]
  end
end
