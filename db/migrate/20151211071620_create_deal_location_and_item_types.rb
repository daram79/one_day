class CreateDealLocationAndItemTypes < ActiveRecord::Migration
  def change
    create_table :deal_location_and_item_types do |t|
      t.integer :deal_search_word_id
      t.integer :item_type_code
      t.string  :item_type_name
      t.timestamps
    end
  end
end
