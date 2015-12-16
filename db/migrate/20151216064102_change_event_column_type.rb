class ChangeEventColumnType < ActiveRecord::Migration
  def change
    remove_column :events, :price
    add_column :events, :price, :integer
  end
end
