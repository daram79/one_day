class AddIndexToEventLogHistorys < ActiveRecord::Migration
  def change
    add_index :event_log_histories, :log_type
  end
end
