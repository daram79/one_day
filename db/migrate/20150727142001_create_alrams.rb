class CreateAlrams < ActiveRecord::Migration
  def change
    create_table :alrams do |t|
      t.integer  :user_id
      t.integer :alram_id
      t.string  :alram_type
      t.integer  :send_user_id
      t.timestamps
    end
    add_index :alrams, :user_id
  end
end
