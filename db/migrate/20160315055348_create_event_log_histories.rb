class CreateEventLogHistories < ActiveRecord::Migration
  def change
    create_table :event_log_histories do |t|
      t.string :label_text
      t.string :value
      t.string  :log_type
      t.timestamps
    end
  end
end
