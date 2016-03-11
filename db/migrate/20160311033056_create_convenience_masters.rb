class CreateConvenienceMasters < ActiveRecord::Migration
  def change
    create_table :convenience_masters do |t|
      t.string :item_name
      t.timestamps
    end
    add_index :convenience_masters, :item_name
  end
end
