class CreateEventMailingLists < ActiveRecord::Migration
  def change
    create_table :event_mailing_lists do |t|
      t.string  :email
      t.boolean :send_flg, default: true
      t.timestamps
    end
    add_index :event_mailing_lists, :send_flg
  end
end
