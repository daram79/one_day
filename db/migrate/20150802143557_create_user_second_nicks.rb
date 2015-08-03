class CreateUserSecondNicks < ActiveRecord::Migration
  def change
    create_table :user_second_nicks do |t|
      t.string :nick
      t.timestamps
    end
  end
end
