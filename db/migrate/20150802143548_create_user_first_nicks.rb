class CreateUserFirstNicks < ActiveRecord::Migration
  def change
    create_table :user_first_nicks do |t|
      t.string :nick
      t.timestamps
    end
  end
end
