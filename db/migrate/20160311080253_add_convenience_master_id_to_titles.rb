class AddConvenienceMasterIdToTitles < ActiveRecord::Migration
  def change
    add_column :convenience_items, :convenience_master_id, :integer
    add_index :convenience_items, [:convenience_master_id, :created_at]
  end
end
