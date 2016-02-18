class AddEventReserveIdToEventImages < ActiveRecord::Migration
  def change
    add_column :event_images, :event_reserve_id, :integer
  end
end
