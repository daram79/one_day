class CreateEventMailingLists < ActiveRecord::Migration
  def change
    create_table :event_mailing_lists do |t|
      t.string  :email
      t.timestamps
    end
  end
end
