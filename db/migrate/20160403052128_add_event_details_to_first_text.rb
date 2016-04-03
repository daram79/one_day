class AddEventDetailsToFirstText < ActiveRecord::Migration
  def change
    add_column :event_details, :first_text, :text
  end
end
