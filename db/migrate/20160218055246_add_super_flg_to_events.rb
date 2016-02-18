class AddSuperFlgToEvents < ActiveRecord::Migration
  def change
    add_column :events, :super_flg, :boolean, default: true
    add_index :events, :super_flg
  end
end
