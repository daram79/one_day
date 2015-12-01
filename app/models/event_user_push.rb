class EventUserPush < ActiveRecord::Base
  after_create :send_push
  
  def send_push
    Thread.new do
      gcm = GCM.new("AIzaSyD_3jJfuO8NT8G-kDHcmTiwl3w0W1JuxXQ")
      user_ids = EventUserPush.where(send_flg: false).group(:event_user_id).pluck(:event_user_id)
      debugger
      event = Event.find(self.event_id)
      option = { :data => {'message' => event.event_name} }
      registration_ids = EventUserRegistrations.where(event_user_id: user_ids).pluck(:registration_id)
      gcm.send(registration_ids, option) unless registration_ids.blank?
    end
  end
end
