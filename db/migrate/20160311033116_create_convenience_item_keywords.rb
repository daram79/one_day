class CreateConvenienceItemKeywords < ActiveRecord::Migration
  def change
    create_table :convenience_item_keywords do |t|
      t.integer :convenience_master_id
      t.string :keyword
      t.timestamps
    end
    add_index :convenience_item_keywords, :keyword
  end
end
