class CreateDealSearchWords < ActiveRecord::Migration
  def change
    create_table :deal_search_words do |t|
      t.string :word
      t.text :nick
      t.timestamps
    end
  end
end
