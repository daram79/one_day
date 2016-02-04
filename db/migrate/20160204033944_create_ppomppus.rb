class CreatePpomppus < ActiveRecord::Migration
  def change
    create_table :ppomppus do |t|
      t.integer :category_id
      t.integer :item_id, :limit => 5
      t.string  :title
      t.string  :url
      t.timestamps
    end
    add_index :ppomppus, [:category_id, :item_id]
  end
end
