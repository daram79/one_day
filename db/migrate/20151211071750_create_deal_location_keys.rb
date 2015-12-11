class CreateDealLocationKeys < ActiveRecord::Migration
  def change
    create_table :deal_location_keys do |t|
      t.integer :deal_location_and_item_type_id
      t.string  :key
      t.timestamps
    end
  end
end
