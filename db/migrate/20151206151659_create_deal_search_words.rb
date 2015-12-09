class CreateDealSearchWords < ActiveRecord::Migration
  def change
    create_table :deal_search_words do |t|
      t.string :word
      t.text :nick
      t.boolean :is_on, default: true
      t.timestamps
    end
    add_index :deal_search_words, :is_on
  end
end
