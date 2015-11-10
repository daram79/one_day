class CreateEventSites < ActiveRecord::Migration
  def change
    create_table :event_sites do |t|
      t.string  :site_name
      t.timestamps
    end
  end
end
