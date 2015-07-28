class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :registration_id
      t.boolean   :alram_on, default: true
      t.timestamps
    end
  end
end
