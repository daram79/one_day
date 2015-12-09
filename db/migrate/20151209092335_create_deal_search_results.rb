class CreateDealSearchResults < ActiveRecord::Migration
  def change
    create_table :deal_search_results do |t|
      t.integer :deal_item_id
      t.string :deal_search_word
      t.timestamps
    end
    add_index :deal_search_results, [:deal_item_id ,:deal_search_word]
  end
end
